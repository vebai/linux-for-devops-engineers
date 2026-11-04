# Linux command quick reference

Run commands only on the intended Linux host. Replace paths with those appropriate to your exercise.

## Orient

```bash
cat /etc/os-release
whoami
hostname
pwd
```

## Files and directories

```bash
ls -a
ls -l
cd ~/devops-lab
find . -maxdepth 2 -type f
cat config/app.conf
head logs/app.log
tail logs/app.log
```

## Permissions

```bash
id
ls -ld ~/devops-lab
ls -l config/app.conf
stat config/app.conf
```

## Text and diagnostic output

```bash
grep -n 'WARNING' logs/app.log
wc -l logs/app.log
tail -n 5 logs/app.log
cat config/missing.conf 2> logs/error.log
cat logs/error.log
```

## System and NGINX

```bash
command -v nginx
systemctl status nginx
systemctl is-active nginx
ps -ef
free -h
df -h
```

## Logs and networking

```bash
journalctl -u nginx -n 20
ip -br addr
ip route
ss -lnt
curl --fail --silent --show-error http://localhost
```

## Bash verification

```bash
bash -n scripts/verify-nginx.sh
./scripts/verify-nginx.sh
echo $?
```

For context, safeguards and expected evidence, follow the relevant chapter README.
