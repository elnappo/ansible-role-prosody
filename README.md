# ansible-role-prosody [![Build Status](https://travis-ci.org/elnappo/ansible-role-prosody.svg?branch=master)](https://travis-ci.org/elnappo/ansible-role-prosody)

Installs and configures a Prosody XMPP server. Get more informations about Prosody at https://prosody.im/

## Requirements
Ubuntu or Debian

## Role Variables
* `prosody_package: prosody` e.g. prosody-0.10 for Prosody v0.10
* `prosody_admins: []`
* `prosody_allow_registration: False`
* `prosody_modules: [ private, vcard, ping, register ]`
* `prosody_s2s_secure_domains: [ jabber.org, jabber.ccc.de, jabber.de ]`
* `prosody_s2s_secure_auth: False`
* `prosody_authentication: internal_hashed`
* `prosody_hosts: [ {domain: localhost} ]`
* `prosody_setup_ufw: True`
  
## Dependencies
None.

## Example Playbook

```yaml
- hosts: servers
  vars:
    prosody_hosts:
      - { domain: example.io,
          ssl_key: /etc/prosody/certs/example.io.key,
          ssl_cert: /etc/prosody/certs/example.io.crt }
    prosody_package: prosody-0.10

  roles:
   - { role: elnappoo.prosody }
```

## License

MIT

## Author Information

elnappo <elnappoo@gmail.com>
