#!/usr/bin/python3
import sys
import pexpect

cmd = "virsh console centos-01"
#cmd = "ls -l"
user_prompt = "localhost login:"
user = "root"
password_prompt = "Password:"
password = "root"
login_ok_prompt = "~]#"

p = pexpect.spawn(cmd, logfile=sys.stdout.buffer)

count=1
p.sendline();
while True:
	index = p.expect([user_prompt, password_prompt, login_ok_prompt,
			pexpect.EOF, pexpect.TIMEOUT], timeout=180)
	if index == 0:
		p.sendline(user)
	elif index == 1:
		p.sendline(password)
	elif index == 2:
		print("test count=%d" % count)
		p.sendline('ip a')
		p.sendline('reboot')
		count += 1
	else:
		print("EOF or TIMEOUT")
		break

p.sendcontrol(']')
p.close()
print ('Test end.')
