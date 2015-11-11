-- This file is ansible managed

{% macro quoted_list(list) %}
{%   if list is defined and list %}
{{     '"%s"' | format(list | join('", "')) -}}
{%   endif %}
{% endmacro %}
{% macro bool(value) %}
{{   'true' if value | bool else 'false' -}}
{% endmacro %}

-- Prosody XMPP Server Configuration
--
-- Information on configuring Prosody can be found on our
-- website at http://prosody.im/doc/configure
--
-- Tip: You can check that the syntax of this file is correct
-- when you have finished by running: prosodyctl check config
-- If there are any errors, it will let you know what and where
-- they are, otherwise it will keep quiet.
--
-- Good luck, and happy Jabbering!


---------- Server-wide settings ----------
-- Settings in this section apply to the whole server and are the default settings
-- for any virtual hosts

-- This is a (by default, empty) list of accounts that are admins
-- for the server. Note that you must create the accounts separately
-- (see http://prosody.im/doc/creating_accounts for info)
-- Example: admins = { "user1@example.com", "user2@example.net" }
admins = { {{ quoted_list(prosody_admins) }} }

-- Enable use of libevent for better performance under high load
-- For more information see: http://prosody.im/doc/libevent
use_libevent = true

-- This is the list of modules Prosody will load on startup.
-- It looks for mod_modulename.lua in the plugins folder, so make sure that exists too.
-- Documentation on modules can be found at: http://prosody.im/doc/modules
modules_enabled = {

	-- Generally required
	"roster"; -- Allow users to have a roster. Recommended ;)
	"saslauth"; -- Authentication for clients and servers. Recommended if you want to log in.
	"tls"; -- Add support for secure TLS on c2s/s2s connections
	"dialback"; -- s2s dialback support
	"disco"; -- Service discovery

	-- Other modules
{% for module in prosody_modules %}
	"{{ module }}";
{% endfor %}

    -- External
{% for module in prosody_external_modules %}
     "{{ module }}";
{% endfor %}

}

-- These modules are auto-loaded, but should you want
-- to disable them then uncomment them here:
modules_disabled = {
	-- "offline"; -- Store offline messages
	-- "c2s"; -- Handle client connections
	-- "s2s"; -- Handle server-to-server connections
	-- "posix"; -- POSIX functionality, sends server to background, enables syslog, etc.
}

-- Disable account creation by default, for security
-- For more information see http://prosody.im/doc/creating_accounts
allow_registration = {{ bool(prosody_allow_registration) }}

-- These are the SSL/TLS-related settings. If you don't want
-- to use SSL/TLS, you may comment or remove this
ssl = {
	key = "/etc/prosody/certs/localhost.key";
	certificate = "/etc/prosody/certs/localhost.crt";
	dhparam = "/etc/prosody/certs/dh-{{ prosody_dhparam_length }}.pem";
{% if prosody_ssl_protocol is defined %}
	protocol = "{{ prosody_ssl_protocol }}";
{% endif %}
{% if prosody_ssl_ciphers is defined %}
	ciphers = "{{ prosody_ssl_ciphers }}";
{% endif %}
}

-- Force clients to use encrypted connections? This option will
-- prevent clients from authenticating unless they are using encryption.

c2s_require_encryption = true
s2s_require_encryption = true

-- Force certificate authentication for server-to-server connections?
-- This provides ideal security, but requires servers you communicate
-- with to support encryption AND present valid, trusted certificates.
-- NOTE: Your version of LuaSec must support certificate verification!
-- For more information see http://prosody.im/doc/s2s#security

s2s_secure_auth = {{ bool(prosody_s2s_secure_auth) }}

-- Many servers don't support encryption or have invalid or self-signed
-- certificates. You can list domains here that will not be required to
-- authenticate using certificates. They will be authenticated using DNS.

--s2s_insecure_domains = { "gmail.com" }

-- Even if you leave s2s_secure_auth disabled, you can still require valid
-- certificates for some domains by specifying a list here.

s2s_secure_domains = { {{ quoted_list(prosody_s2s_secure_domains) }} }

-- Required for init scripts and prosodyctl
pidfile = "/var/run/prosody/prosody.pid"

-- Select the authentication backend to use. The 'internal' providers
-- use Prosody's configured data storage to store the authentication data.
-- To allow Prosody to offer secure authentication mechanisms to clients, the
-- default provider stores passwords in plaintext. If you do not trust your
-- server please see http://prosody.im/doc/modules/mod_auth_internal_hashed
-- for information about using the hashed backend.

authentication = "{{ prosody_authentication }}"

-- Select the storage backend to use. By default Prosody uses flat files
-- in its configured data directory, but it also supports more backends
-- through modules. An "sql" backend is included by default, but requires
-- additional dependencies. See http://prosody.im/doc/storage for more info.

--storage = "sql" -- Default is "internal"

-- For the "sql" backend, you can uncomment *one* of the below to configure:
--sql = { driver = "SQLite3", database = "prosody.sqlite" } -- Default. 'database' is the filename.
--sql = { driver = "MySQL", database = "prosody", username = "prosody", password = "secret", host = "localhost" }
--sql = { driver = "PostgreSQL", database = "prosody", username = "prosody", password = "secret", host = "localhost" }

-- Logging configuration
-- For advanced logging see http://prosody.im/doc/logging
log = {
	info = "/var/log/prosody/prosody.log"; -- Change 'info' to 'debug' for verbose logging
	error = "/var/log/prosody/prosody.err";
	"*syslog";
}

----------- Virtual hosts -----------
-- You need to add a VirtualHost entry for each domain you wish Prosody to serve.
-- Settings under each VirtualHost entry apply *only* to that host.

{% for host in prosody_hosts %}
VirtualHost "{{ host.domain }}"
{% if host.ssl_cert is defined and host.ssl_key is defined %}
	ssl = {
		key = "{{ host.ssl_key }}";
		certificate = "{{ host.ssl_cert }}";
	}
{% endif %}
{% endfor %}

------ Components ------
-- You can specify components to add hosts that provide special services,
-- like multi-user conferences, and transports.
-- For more information on components, see http://prosody.im/doc/components

---Set up a MUC (multi-user chat) room server on conference.example.com:
--Component "conference.example.com" "muc"

-- Set up a SOCKS5 bytestream proxy for server-proxied file transfers:
--Component "proxy.example.com" "proxy65"

---Set up an external component (default component port is 5347)
--
-- External components allow adding various services, such as gateways/
-- transports to other networks like ICQ, MSN and Yahoo. For more info
-- see: http://prosody.im/doc/components#adding_an_external_component
--
--Component "gateway.example.com"
--	component_secret = "password"
