openssl req -newkey rsa:2048 -nodes -keyout node.key -x509 -days 365 -out cert.crt -subj "/CN=yourip" -addext "subjectAltName=IP:yourip"