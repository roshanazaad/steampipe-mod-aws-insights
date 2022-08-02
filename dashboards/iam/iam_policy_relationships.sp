dashboard "aws_iam_policy_relationships" {
  title         = "AWS IAM Policy Relationships"
  #documentation = file("./dashboards/iam/docs/iam_policy_relationships.md")
  tags = merge(local.iam_common_tags, {
    type = "Relationships"
  })
  
  input "policy_arn" {
    title = "Select a policy:"
    query = query.aws_iam_policy_input
    width = 4
  }
  
  graph {
    type  = "graph"
    title = "Things I use..."
    query = query.aws_iam_policy_graph_from_policy
    args = {
      arn = self.input.policy_arn.value
    }
  }
  
  graph {
    type  = "graph"
    title = "Things that use me..."
    query = query.aws_iam_policy_graph_to_policy
    args = {
      arn = self.input.policy_arn.value
    }
    category "aws_iam_policy" {
      color = "orange"
    }

    category "aws_iam_role" {
      color = "yellow"
      href  = "${dashboard.aws_iam_role_detail.url_path}?input.role_arn={{.properties.ARN | @uri}}"
      icon = format("%s,%s", "image://data:image/svg+xml;base64", filebase64("./icons/aws_iam_role.svg"))
    }

    category "aws_iam_user" {
      color = "blue"
      href  = "${dashboard.aws_iam_user_detail.url_path}?input.user_arn={{.properties.ARN | @uri}}"
    }
    
    category "aws_iam_group" {
      color = "blue"
      href  = "${dashboard.aws_iam_group_detail.url_path}?input.group_arn={{.properties.ARN | @uri}}"
    }

    category "uses" {
      color = "green"
    }
  }
}

query "aws_iam_policy_input" {
  sql = <<-EOQ
    select
      title as label,
      arn as value,
      json_build_object(
        'account_id', account_id
      ) as tags
    from
      aws_iam_policy
    order by
      title;
  EOQ
}

query "aws_iam_policy_graph_from_policy" {
  sql = <<-EOQ
    select
      null as from_id,
      null as to_id,
      name as id,
      name as title,
      'aws_iam_policy' as category,
      jsonb_build_object(
        'Policy ID', policy_id,
        'ARN', arn,
        'Account ID', account_id,
        'Region', region
      ) as properties
    from
      aws_iam_policy
    where
      arn = $1;   
  EOQ
  
  param "arn" {}
}

query "aws_iam_policy_graph_to_policy" {
  sql = <<-EOQ
    select
      null as from_id,
      null as to_id,
      policy_id as id,
      name as title,
      'aws_iam_policy' as category,
      jsonb_build_object(
        'ARN', arn,
        'Account ID', account_id
      ) as properties
    from
      aws_iam_policy
    where
      arn = $1

    -- Role - nodes
    union all
    select
      null as from_id,
      null as to_id,
      role_id as id,
      name as title,
      'aws_iam_role' as category,
      jsonb_build_object(
        'ARN', arn,
        'Account ID', account_id
      ) as properties
    from
      aws_iam_role,
      jsonb_array_elements_text(attached_policy_arns) as arns
    where
      arns = $1

    -- Role - Edges
    union all
    select
      p.policy_id as from_id,
      r.role_id as to_id,
      null as id,
      'uses' as title,
      'uses' as category,
      jsonb_build_object(
        'Role Name', r.name, 
        'ARN', r.arn    
      ) as properties
    from
      aws_iam_role as r,
      jsonb_array_elements_text(attached_policy_arns) as arns 
      left join aws_iam_policy as p on p.arn = arns 
    where 
      p.arn = $1       
    
     -- User - nodes
    union all
    select
      null as from_id,
      null as to_id,
      u.name as id,
      u.name as title,
      'aws_iam_user' as category,
      jsonb_build_object(
        'ARN', u.arn,
        'Account ID', u.account_id
      ) as properties
    from
      aws_iam_user as u,
      jsonb_array_elements_text(attached_policy_arns) as arns
    where
      arns = $1  
    
    -- User - Edges
    union all
    select
      p.policy_id as from_id,
      u.name as to_id,
      null as id,
      'uses' as title,
      'uses' as category,
      jsonb_build_object(
        'ARN', u.arn,
        'Account ID', u.account_id
      ) as properties
    from
      aws_iam_user as u,
      jsonb_array_elements_text(attached_policy_arns) as arns,
      aws_iam_policy as p
    where
      p.arn = arns and p.arn = $1

    
    -- Group - nodes
    union all
    select
      null as from_id,
      null as to_id,
      g.name as id,
      g.name as title,
      'aws_iam_group' as category,
      jsonb_build_object(
        'ARN', g.arn,
        'Account ID', g.account_id
      ) as properties
    from
      aws_iam_group as g,
      jsonb_array_elements_text(attached_policy_arns) as arns
    where
      arns = $1

    -- Group - Edges
    union all
    select
      p.policy_id as from_id,
      g.name as to_id,
      null as id,
      'uses' as title,
      'uses' as category,
      jsonb_build_object(
        'ARN', g.arn,
        'Account ID', g.account_id
      ) as properties
    from
      aws_iam_group as g,
      jsonb_array_elements_text(attached_policy_arns) as arns,
      aws_iam_policy as p
    where
      p.arn = arns and p.arn = $1 
    order by 
      category,from_id,to_id
  EOQ
  
  param "arn" {}
}