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
	try:
		index = p.expect([user_prompt, login_ok_prompt], timeout=180)
		if index == 0:
			p.sendline(user)
			p.expect([password_prompt], timeout=10)
			p.sendline(password)
		elif index == 1:
			print("test count=%d" % count)
			p.sendline('ip a')
			p.sendline('reboot')
			count += 1
	except:
		print("EOF or TIMEOUT")
		break

p.sendcontrol(']')
p.close()
print ('Test end.')
