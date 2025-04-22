output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

#Its secure when we marked sensitive. Can get key with terraform output
output "bastion_private_key_pem" {
  value     = tls_private_key.bastion_tls.private_key_pem
  sensitive = true
}

output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}
