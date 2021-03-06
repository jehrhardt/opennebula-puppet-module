#
# == Class one::prerequisites
#
# Installation and Configuration of OpenNebula
# http://opennebula.org/
#
# === Author
# ePost Development GmbH
# (c) 2013
#
# Contributors:
# - Martin Alfke
# - Achim Ledermüller (Netways GmbH)
# - Sebastian Saemann (Netways GmbH)
# - Thomas Fricke (Endocode AG)
#
# === License
# Apache License Version 2.0
# http://www.apache.org/licenses/LICENSE-2.0.html
#
class one::prerequisites {
    if ( hiera(one::enable_opennebula__repo, false ) == true ) {
        yumrepo { 'opennebula':
            baseurl  => 'http://opennebula.org/repo/CentOS/6/stable/$basearch/',
            descr    => 'OpenNebula',
            enabled  => 1,
            gpgcheck => 0,
        }
    }
}
