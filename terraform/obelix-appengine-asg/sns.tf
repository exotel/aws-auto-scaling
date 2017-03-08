resource "aws_sns_topic" "devops_emails_obelix_appengine" {
    name = "send_emails_to_devops"
    
}

resource "aws_sns_topic_policy" "devops_emails_obelix_appengine_policy" {
    arn = "${aws_sns_topic.devops_emails_obelix_appengine.arn}"
    policy = <<POLICY
    {
      "Version": "2012-10-17",
      "Id": "default",
      "Statement":[{
        "Sid": "default",
        "Effect": "Allow",
        "Principal": {"AWS":"*"},
        "Action": [
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish",
        "SNS:Receive"
        ],
        "Resource": "${aws_sns_topic.devops_emails_obelix_appengine.arn}"
      }]
    }
    POLICY
}