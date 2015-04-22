#!/usr/bin/env bash
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

ERRS=0
TESTS=0

CIPHER=$(mktemp -t "$0")
CORRECT=$(mktemp -t "$0")
CRACKED=$(mktemp -t "$0")

function check()
{
	TESTS=$((TESTS + 1))
	diff "$CORRECT" "$CRACKED" >/dev/null
	if [ $? -eq 0 ] ; then
		echo -n "."
	else
		echo -n "!" 
		ERRS=$((ERRS + 1))
	fi
}

function crack()
{
	key="$1"
	cipher="$2"
	if [ "$key" = "" ]; then
		./test_with_key.py $cipher | tail -n 1 > "$CRACKED"
	else
		./test_with_key.py "$key" $cipher | tail -n 1 > "$CRACKED"
	fi
}

# Some provided cryptos

crack "" 19e27c9b5411608f9a8909c21eee2a61198b124de41f6e8d41ff1f22b3c60e789cd370bf2e2c88ad08643a5769e99264a5659ee34fe4dc03c269bd2af255edcf
echo "The magic words are squeamish ossifrage">"$CORRECT"
check

crack "" ac1939ede54a02b3ce6504945063ec7a0be0da33b72b68783019102ebe6b32d3
echo -e "123456789ABCDE\x02">"$CORRECT"
check

crack "" 92fd508cadb2bef14554d43a79394332ff00adebd197025f980f829c95f57305
echo "-- Snip --">"$CORRECT"
check

crack "" fa485ab028cb239a39a9e52df1ebf4c30911b25d73f8906cc45b6bf87f7a693f47609094ccca42050ad609bb3cf979ac
echo "Ahoj, jak se Ti vede0000000000?">"$CORRECT"
check

 crack "sixteen_byte_key" a1372965b3a651999c1ef019fef1402c32f7847fdd0f2b29a0d3135dc4dd54c9507c91f2f1a7fc863a572db4bab0d64e13d5469a2e31f2d8c2ada6f4cca72f4623cd39bc7f4cb16df995392c98b785512058c27fb543ac15d6aad12942f87d336e27216fd0ab7839fe64ead0b6e20fbf23e5b5ca8c4fd074772bb3eb9a8efbd65be42c0ead9a4a20ff057b0e615d932cc80fe7e886e96cd46adef0edaf63422153f973399a70751c89e766ffa360be7cc3d707018195cf19244bae6258abcc6a
 echo "There are two types of cyptography: one that allows the Government to use brute force to break the code, and one that requires the Government to use brute force to break you.">"$CORRECT"
 check
 
 crack "sixteen_byte_key" 5a36670ff5cb94ba2509e3f0ae74db879e239644b5e7a924f4c9fff6368500c3d84e9aa2f84a80d33ee7f2a18d4f4c5f65214fcf4f42dba2f5da24d7eb19e0b1cfca111cc6e4f7ef88e745f91c4632a54764090361083afc90deefef42737984a3461033d448fa012a979a2984b4c43640fb1e77bbf23890e45c0a69c92273c8dd23e58ceb1015c51a90b40a594aedc553e54b9452b735c8c8b677a37ac2d3962c75c1c2adb3b45698583da8c5a58d22dde58bb5ed7f66bb6874d305822ac0e6
 echo "Key escrow to rule them all; key escrow to find them. Key escrow to bring them all and in the darkness bind them. In the land of surveillance where Big Brother lies.">"$CORRECT"
 check

# custom crypto
for key in "0000000000000000" "abcdefghijklmnopqrstuvwx"
do
	for text in "holaholaholaholahola hola hola hola" "zkouska zkouska" "abc" "Ahoj, jak se Ti vede0000000000?"
	do
		echo "$text" > "$CORRECT"
		cipher=$(./encrypt.py "$text" "$key")
		echo "$cipher" > "$CIPHER"
		crack "$key" "$cipher"
		check
	done
done


echo
echo "Tests run: $TESTS, tests failed: $ERRS"

rm -f "$CIPHER" "$CORRECT" "$CRACKED"
