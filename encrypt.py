#!/usr/bin/env python2.7
# vim: set noexpandtab cindent sw=4 ts=4:
#
# (C)2014 Jan Tulak <jan@tulak.me>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import sys
from OracleModule import paddingOracle
#from OracleModule import genNewKey
from OracleModule import setKey
from OracleModule import encrypt

def str2hex(b):
	out=[]
	for n in b:
		out.append("%0.2x" % ord(n))
	return "".join(out)

if __name__ == "__main__":
	if len(sys.argv) == 2:
		msg = sys.argv[1]
	elif len(sys.argv) == 3:
		key = sys.argv[2]
		msg = sys.argv[1]
		setKey(key)
	else:
		print "Usage: %s MSG [KEY]" % sys.argv[0]
		sys.exit(1)

	enc = encrypt(msg)
	print(str2hex(encrypt(msg)))

	sys.exit(0)
	
