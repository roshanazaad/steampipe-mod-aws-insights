dashboard "backup_vault_detail" {

  title         = "AWS Backup Vault Detail"
  documentation = file("./dashboards/backup/docs/backup_vault_detail.md")

  tags = merge(local.backup_common_tags, {
    type = "Detail"
  })

  input "backup_vault_arn" {
    title = "Select a vault:"
    query = query.aws_backup_vault_input
    width = 4
  }

  container {

    card {
      query = query.aws_backup_vault_recovery_points
      width = 2
      args = {
        arn = self.input.backup_vault_arn.value
      }
    }
  }

  container {
    graph {
      type  = "graph"
      base  = graph.aws_graph_categories
      query = query.aws_backup_vault_relationships_graph
      args = {
        arn = self.input.backup_vault_arn.value
      }
      category "aws_backup_vault" {
        icon = local.aws_backup_vault_icon
      }
    }
  }

  container {

    container {

      table {
        title = "Overview"
        type  = "line"
        width = 3
        query = query.aws_backup_vault_overview
        args = {
          arn = self.input.backup_vault_arn.value
        }

      }

      table {
        title = "Policy"
        width = 9
        query = query.aws_backup_vault_policy
        args = {
          arn = self.input.backup_vault_arn.value
        }

      }
    }
  }
}

query "aws_backup_vault_input" {
  sql = <<-EOQ
    select
      title as label,
      arn as value,
      json_build_object(
        'account_id', account_id,
        'region', region
      ) as tags
    from
      aws_backup_vault
    order by
      arn;
  EOQ
}

query "aws_backup_vault_recovery_points" {
  sql = <<-EOQ
    select
      'Recovery Points' as label,
      number_of_recovery_points as value
    from
      aws_backup_vault
    where
      arn = $1;
  EOQ

  param "arn" {}
}

query "aws_backup_vault_relationships_graph" {
  sql = <<-EOQ
    select
      null as from_id,
      null as to_id,
      arn as id,
      title as title,
      'aws_backup_vault' as category,
      jsonb_build_object(
        'ARN', arn,
        'Name', name,
        'Creation Date', creation_date,
        'Account ID', account_id,
        'Region', region ) as properties
    from
      aws_backup_vault
    where
      arn = $1

    -- From Backup plans (node)
    union all
    select
      null as from_id,
      null as to_id,
      arn as id,
      title as title,
      'aws_backup_plan' as category,
      jsonb_build_object(
        'ARN', arn,
        'Name', name,
        'Backup Plan ID', backup_plan_id,
        'Creation Date', creation_date,
        'Account ID', account_id,
        'Region', region ) as properties
    from
      aws_backup_plan,
      jsonb_array_elements(backup_plan -> 'Rules') as r
    where
      r ->> 'TargetBackupVaultName' in
      (
        select
          name
        from
          aws_backup_vault
        where
          arn = $1
      )

    -- From Backup plans (edge)
    union all
     select
      p.arn as from_id,
      v.arn as to_id,
      null as id,
      'backup plan' as title,
      'backup_plan_to_backup_vault' as category,
      jsonb_build_object(
        'Account ID', v.account_id ) as properties
    from
      aws_backup_vault as v,
      aws_backup_plan as p,
      jsonb_array_elements(backup_plan -> 'Rules') as r
    where
      r ->> 'TargetBackupVaultName' = v.name
      and v.arn = $1

    -- From KMS keys (node)
    union all
    select
      null as from_id,
      null as to_id,
      id as id,
      title as title,
      'aws_kms_key' as category,
      jsonb_build_object(
        'ARN', arn,
        'Key Manager', key_manager,
        'Creation Date', creation_date,
        'Enabled', enabled::text,
        'Account ID', account_id,
        'Region', region ) as properties
    from
      aws_kms_key
    where
      arn in
      (
        select
          encryption_key_arn
        from
          aws_backup_vault
        where
          arn = $1
      )

    -- From KMS keys (edge)
    union all
    select
      v.arn as from_id,
      k.id as to_id,
      null as id,
      'encrypted with' as title,
      'backup_vault_to_kms_key' as category,
      jsonb_build_object(
        'Account ID', v.account_id ) as properties
    from
      aws_backup_vault as v
      left join
        aws_kms_key as k
        on k.arn = v.encryption_key_arn
    where
      v.arn = $1

    -- From SNS topics (node)
    union all
    select
      null as from_id,
      null as to_id,
      topic_arn as id,
      title as title,
      'aws_sns_topic' as category,
      jsonb_build_object(
        'ARN', topic_arn,
        'Account ID', account_id,
        'Region', region ) as properties
    from
      aws_sns_topic
    where
      topic_arn in
      (
        select
          sns_topic_arn
        from
          aws_backup_vault
        where
          arn = $1
      )

    -- From SNS topics (edge)
    union all
    select
      v.arn as from_id,
      t.topic_arn as to_id,
      null as id,
      'publishes to' as title,
      'backup_vault_to_sns_topic' as category,
      jsonb_build_object(
        'Account ID', v.account_id ) as properties
    from
      aws_backup_vault as v
      left join
        aws_sns_topic as t
        on t.topic_arn = v.sns_topic_arn
    where
      arn = $1

    order by
      category,
      from_id,
      to_id;
  EOQ

  param "arn" {}
}

query "aws_backup_vault_overview" {
  sql = <<-EOQ
    select
      title as "Title",
      creation_date as "Creation Date",
      region as "Region",
      account_id as "Account ID",
      arn as "ARN"
    from
      aws_backup_vault
    where
      arn = $1;
  EOQ

  param "arn" {}
}

query "aws_backup_vault_policy" {
  sql = <<-EOQ
    select
      s -> 'Action' as "Action",
      s -> 'Effect' as "Effect",
      s -> 'Resource' as "Resource",
      s -> 'Principal' as "Principal"
    from
      aws_backup_vault,
      jsonb_array_elements(policy_std -> 'Statement') as s
    where
      arn = $1;
  EOQ

  param "arn" {}
}