# ansible-role-prosody [![Build Status](https://travis-ci.org/elnappo/ansible-role-prosody.svg?branch=master)](https://travis-ci.org/elnappo/ansible-role-prosody)

Installs and configures a Prosody XMPP server. Get more informations about Prosody at https://prosody.im

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
* `prosody_hosts: [ {domain: example.com} ]`
* `prosody_setup_ufw: True`

### Optional Role Variables (with sample values)
* `prosody_ssl_protocol: tlsv1_2`
* `prosody_ssl_ciphers: "ECDH:DH:!CAMELLIA128:!3DES:!MD5:!RC4:!aNULL:!NULL:!EXPORT:!LOW:!MEDIUM"` use only ciphers with PFS

## Dependencies
None.

## Example Playbook

```yaml
- hosts: servers
  vars:
    prosody_hosts:
      - { domain: example.com,
          ssl_key: /etc/prosody/certs/example.com.key,
          ssl_cert: /etc/prosody/certs/example.com.crt }
    prosody_package: prosody-0.10
    prosody_ssl_ciphers: "ECDH:DH:!CAMELLIA128:!3DES:!MD5:!RC4:!aNULL:!NULL:!EXPORT:!LOW:!MEDIUM"
    prosody_ssl_protocol: tlsv1_1+ # tlsv1_1+ supported since Prosody 0.10

  roles:
   - { role: elnappoo.prosody }
```

## License

MIT

## Author Information

elnappo <elnappoo@gmail.com>
