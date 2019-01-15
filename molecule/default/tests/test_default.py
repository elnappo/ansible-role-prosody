import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_prosody_server_is_installed(host):
    prosody = host.package('prosody')

    assert prosody.is_installed


def test_prosody_is_running(host):
    prosody = host.service('prosody')

    assert prosody.is_running
    assert prosody.is_enabled


def test_prosody_is_listening(host):
    assert host.socket("tcp://0.0.0.0:5222").is_listening
    assert host.socket("tcp://0.0.0.0:5269").is_listening
