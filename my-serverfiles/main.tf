resource "aws_instance" "test-server" {
  ami           = "ami-00bb6a80f01f03502" 
  instance_type = "t2.micro" 
  key_name = "Prabhu"
  vpc_security_group_ids= ["sg-0ce7a707b375e270d"]
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("./Prabhu.pem")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "test-server"
  }
  provisioner "local-exec" {
        command = " echo ${aws_instance.test-server.public_ip} > inventory "
  }
   provisioner "local-exec" {
  command = "ansible-playbook /var/lib/jenkins/workspace/Banking-finance-project/my-serverfiles/finance-playbook.yml "
  } 
}
