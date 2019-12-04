# ansible-role-prosody
[![Build Status](https://travis-ci.org/elnappo/ansible-role-prosody.svg?branch=master)](https://travis-ci.org/elnappo/ansible-role-prosody) [![Ansible Galaxy](https://img.shields.io/badge/galaxy-elnappo.prosody-blue.svg?style=flat)](https://galaxy.ansible.com/elnappo/prosody/)

Installs and configures a Prosody XMPP server. Get more information about Prosody at https://prosody.im

## Requirements

Ubuntu or Debian

## Role Variables

* `prosody_package: prosody` e.g. prosody-0.11 for Prosody v0.11
* `prosody_admins: []`
* `prosody_allow_registration: False`
* `prosody_modules: [ private, vcard, ping, register ]`
* `prosody_external_modules: []`
* `prosody_external_modules_path: /usr/share/prosody-external-modules`
* `prosody_s2s_secure_domains: [ jabber.org, jabber.ccc.de, jabber.de ]`
* `prosody_s2s_secure_auth: False`
* `prosody_authentication: internal_hashed`
* `prosody_dhparam_length: 2048`
* `prosody_hosts: [ {domain: example.com} ]`
* `prosody_setup_ufw: True`
* `prosody_components: []`
* `prosody_configuration_blocks: []`
* `prosody_key: /etc/prosody/certs/localhost.key`
* `prosody_cert: /etc/prosody/certs/localhost.crt`

### Optional Role Variables (with sample values)

* `prosody_ssl_protocol: tlsv1_2`
* `prosody_ssl_ciphers: "ECDH:DH:!CAMELLIA128:!3DES:!MD5:!RC4:!aNULL:!NULL:!EXPORT:!LOW:!MEDIUM"` use only ciphers with PFS

## Dependencies

None.

## Example Playbook

```yaml
- hosts: servers
  remote_user: root
  vars:
    prosody_hosts:
      - domain: example.com
        ssl_key: /etc/prosody/certs/example.com.key
        ssl_cert: /etc/prosody/certs/example.com.crt
    prosody_package: prosody-0.11
    prosody_ssl_ciphers: "ECDH:DH:!CAMELLIA128:!AES128:!SHA1:!3DES:!MD5:!RC4:!aNULL:!NULL:!EXPORT:!LOW:!MEDIUM"
    prosody_ssl_protocol: tlsv1_2+ # tlsv1_2+ supported since Prosody 0.10
    prosody_dhparam_length: 4096
    prosody_components:
      - domain: rooms.example.org
        type: muc
        conf: |
          name = "The example.org chatrooms server"
          modules_enabled = { "muc_mam", "vcard_muc" }
          ssl = {
              key = "/etc/prosody/certs/rooms.example.org.key";
              certificate = "/etc/prosody/certs/rooms.example.org.crt";
          }
    prosody_modules:
      - motd
    prosody_configuration_blocks:
      - comment: motd
        conf: |
          motd_text = "Welcome on example.org !"

  roles:
   - elnappo.prosody
```

## License

MIT

## Author Information

elnappo <elnappo@nerdpol.io>
