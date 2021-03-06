# == Class one::params
#
# Installation and Configuration of OpenNebula
# http://opennebula.org/
#
# Sets required variables
# read some data from hiera, but also has defaults.
#
# === Author
# ePost Development GmbH
# (c) 2013
#
# Contributors:
# - Martin Alfke
# - Achim Ledermüller (Netways GmbH)
# - Sebastian Saemann (Netways GmbH)
#
# === License
# Apache License Version 2.0
# http://www.apache.org/licenses/LICENSE-2.0.html
#
class one::params {
  # params for nodes and oned
  $oneid = $one::oneid

  # params for nodes
  case $::osfamily {
    'RedHat': {
      $node_packages = ['libvirt',
                        'qemu-kvm',
                        'bridge-utils',
                        'vconfig',
                        'opennebula-node-kvm',
                        'sudo',
                        ]
    }
    default: {
      fail("Your OS - ${::osfamily} - is not yet supported.
            Please add required functionality to params.pp")
    }
  }
  $oneuid = '9869'
  $onegid = '9869'

  $ssh_priv_key = hiera('one::node::ssh_priv_key', '....')
  $ssh_pub_key = hiera('one::node::ssh_pub_key', '....')

  # params for oned management cli
  case $::osfamily {
    'RedHat': {
      $oned_packages   = ['opennebula', 'opennebula-server', 'opennebula-ruby']
      $dbus_srv        = 'messagebus'
      $dbus_pkg        = 'dbus'
    }
    'Debian': {
      $dbus_srv        = 'dbus'
      $dbus_pkg        = 'dbus'
      fail("Your OS (${::osfamily} is not yet supported.
            Please add variable oned_packages to params.pp")
        }
    default: {
      fail("Your OS (${::osfamily} is not yet supported.
            Please add required functionality to params.pp")
    }
  }

  # mysql stuff (optional, need one::mysql set to true)
  $oned_db     = hiera('one::oned::db', 'oned')
  $oned_db_user   = hiera('one::oned::db_user', 'oned')
  $oned_db_password   = hiera('one::oned::db_password', 'oned')
  $oned_db_host   = hiera('one::oned::db_host', 'localhost')

  # ha stuff (optional, needs one::ha_setup set to true)
  if($one::ha_setup) {
    $oned_enable = false
    $oned_ensure = undef
  } else {
    $oned_enable = true
    $oned_ensure = 'running'
  }

  # ldap stuff (optional needs one::oned::ldap in hiera set to true)
  # $oned_ldap_user: can be empty if anonymous query is possible
  $oned_ldap_user = hiera('one::oned::ldap_user',
                          'cn=ldap_query,ou=user,dc=example,dc=com')
  $oned_ldap_pass = hiera('one::oned::ldap_pass','default_password')
  $oned_ldap_host = hiera('one::oned::ldap_host','ldap')
  $oned_ldap_port = hiera('one::oned::ldap_port','636')
  $oned_ldap_base = hiera('one::oned::ldap_base','dc=example,dc=com')

  # $oned_ldap_group: can be empty,
  #                   can be set to a group to restrict access to sunstone
  $oned_ldap_group = hiera( 'one::oned::ldap_group', 'undef')

  # $oned_ldap_user_field: defaults to uid, can be set to the field,
  #                        that holds the username in ldap
  $oned_ldap_user_field = hiera('one::oned::ldap_user_field','undef')

  # $oned_ldap_group_field: default to member,
  #                         can be set to the filed that holds the groupname
  $oned_ldap_group_field = hiera('one::oned::ldap_group_field', 'undef')

  # $oned_ldap_user_group_field: default to dn,
  #                can be set to the user field that is in the group group_field
  $oned_ldap_user_group_field = hiera('one::oned::ldap_user_group_field','undef')

  # params for sunstone (needs one::sunstone set to true)
  $oned_sunstone_packages = 'opennebula-sunstone'
  $oned_sunstone_ldap_pkg = ['ruby-ldap','rubygem-net-ldap']

  # params for oneflow (optional, needs one::oneflow set to true)
  $oned_oneflow_packages = ['opennebula-flow',
                            'rubygem-treetop',
                            'rubygem-polyglot',
                            ]

  # params for onegate (optional, needs one::onegate set to true)
  $oned_onegate_packages = ['opennebula-gate', 'rubygem-parse-cron']
  # Todo: Use Serviceip from HA-Setup if ha enabled.
  $oned_onegate_ip = hiera('one::oned::onegate::ip', $::ipaddress)
}
