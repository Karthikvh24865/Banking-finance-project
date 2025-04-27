resource "aws_instance" "test-server" {
  ami           = "ami-00bb6a80f01f03502" 
  instance_type = "t2.micro" 
  key_name = "huli"
  vpc_security_group_ids= ["sg-0f9b64f0f5bafa7e0"]
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("./huli.pem")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "test-server"
  }
 provisioner "local-exec" {
      command = "echo ${aws_instance.test-server.public_ip} > /etc/ansible/hosts "
}
//provisioner "local-exec" {
 // command = "echo ${aws_instance.test-server.public_ip} > /etc/ansible/hosts "
//}
  provisioner "local-exec" {
    command = "echo '${self.public_ip} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=./huli.pem' | sudo tee -a /etc/ansible/hosts"
  }

   provisioner "local-exec" {
  command = "ansible-playbook /var/lib/jenkins/workspace/Banking-finance-project/my-serverfiles/finance-playbook.yml "
  } 
}
