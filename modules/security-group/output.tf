output "alb_security_group_id" {
    value = aws_security_group.alb-security-group.id 
}

output "ecs_security_group_id" {
    value = aws_security_group.ecs_security_group.id 
}