Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57369 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbZAPTln (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 14:41:43 -0500
Message-ID: <4970DC58.3000507@hauke-m.de> (sfid-20090116_204148_036776_739D1A28)
Date: Fri, 16 Jan 2009 20:13:28 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Kalle Valo <kalle.valo@iki.fi>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: garbaged AP mac address in dmesg in wireless-testing?
References: <3ace41890901160907w2d04da91r61744477ac64e018@mail.gmail.com>	<20090116183826.GC10037@tuxdriver.com> <87ocy7xejp.fsf@litku.valot.fi>
In-Reply-To: <87ocy7xejp.fsf@litku.valot.fi>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC06618AAB40150A42A640D6F"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC06618AAB40150A42A640D6F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Kalle Valo wrote:
> "John W. Linville" <linville@tuxdriver.com> writes:
>=20
>> On Fri, Jan 16, 2009 at 05:07:50PM +0000, Hin-Tak Leung wrote:
>>> Since a few days ago, my dmesg is looking like this - instead of the
>>> older AA:BB:CC:DD:EE:FF form
>>> with the mac address of the AP.
>>> That ffff88* looks like a pointer/address to me? Is this change inten=
tional?
>>>
>>> --------------
>>> wlan2 direct probe responded
>>> wlan2: authenticate with AP ffff880070995aa0
>>> wlan2: authenticated
>>> wlan2: associate with AP ffff880070995aa0
>>> wlan2: RX ReassocResp from ffff88001431f01a (capab=3D0x431 status=3D0=
 aid=3D1)
>>> wlan2: associated
>=20
> Works for me:
>=20
> [37125.111672] wlan0: authenticate with AP 00:12:17:e7:98:de
> [37125.113509] wlan0: authenticated
> [37125.113514] wlan0: associate with AP 00:12:17:e7:98:de
> [37125.115875] wlan0: RX AssocResp from 00:12:17:e7:98:de (capab=3D0x11=
 status=3D0 aid=3D1)
> [37125.115881] wlan0: associated
>=20
> This is on x86 32bit with iwl3945 and latest wireless-testing.
>=20
>> Odd...some problem with the "%pM" printk conversion?  What kernel
>> are you running?
>=20
> And on what architecture?
>=20

I have got the same problem on x86_64 with rtl8187, kernel 2.6.27 and
compat-wireless-2008-01-16.

[ 3064.480766] wlan0: authenticate with AP ffff8801291dfa20
[ 3064.482271] wlan0: authenticated
[ 3064.482275] wlan0: associate with AP ffff8801291dfa20
[ 3064.485021] wlan0: RX AssocResp from ffff88011128c01a (capab=3D0x411
status=3D0 aid=3D1)
[ 3064.485025] wlan0: associated

Hauke


--------------enigC06618AAB40150A42A640D6F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJJcNxeAAoJEIZ0px9YPRMyicYP/3OBuqussJ9kZnBPKDoiR1sM
Y93bYjOWDe89hqjzCiCB4kHbaQp9vhvJ5FMbYqbQJkdyQdgHpclaMbYw8+UKeblm
UiB6OCS94FM88LDHJaN2YcpPZzuy0EUEphSID3piLvNQj+pColqpx8HohICKssqi
fl1RN9TTv/S4NHxfNl+8gp0DhUIwMFpthTIdNrHwOyY/nYpUOtfPJfE3DiRI0kyO
g+JKClg21LsjkA98kAllei3qCx8S/MF8gp99Guee3WfsEAFp7kAx5ALhfEXWVwix
mte31xtK8o+jeNbEE3ooyv8ihaSAF413afTkBHI8YGVTccO7dYOQNeNbgK1VRxRc
GfK7PwBPiXucEfDjp7y8e1YhPghPgkTCEYmLA7DZ2e7LlMyOds+nNQLh8p4AqLQC
eDI/JE/gzVyEWomoKjN8ShifwORwBhr00etY18q20luqmJOTWcJybsw4ND4+2846
7ut0VNYHe4N33VxfSW4cV16tplONa46p9EVT/3C+1rHfHDSoIHbAcTtRUMM9oZwq
sYNKpihbo4kIKma75dcIJxLR4MPcpdymJUEfA/kCyn5NtHmgkdu0kbM8lAlxUgN4
8xLa3mj2I1Bkipo57UmdFV+trbywFKjtlHjNckeVEVzfHkqqbRKCGxrGUoFAfglc
wmhPkiYAc2PR8/0//A9b
=q7ZM
-----END PGP SIGNATURE-----

--------------enigC06618AAB40150A42A640D6F--
