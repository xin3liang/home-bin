from paramiko import SSHClient

cmd = 'python -m /home/ubuntu/tmp/example'
ssh = SSHClient()
ssh.load_system_host_keys()

ssh.connect(hostname='localhost', port='444')

print('started...')
stdin, stdout, stderr = ssh.exec_command(cmd, get_pty=True)

for line in iter(stdout.readline, ""):
    print(line, end="")
print('finished.')
