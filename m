Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54386 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbZC3JlB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 05:41:01 -0400
Subject: Re: [RFC] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>, toshiba_acpi@memebeam.org,
	Matthew Garrett <mjg@redhat.com>
In-Reply-To: <1238349195.24972.5.camel@johannes.local> (sfid-20090329_195345_745378_2F2074B3)
References: <1238349195.24972.5.camel@johannes.local>
	 (sfid-20090329_195345_745378_2F2074B3)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-BSyDxkG2EU8AScMNqK/V"
Date: Mon, 30 Mar 2009 11:40:57 +0200
Message-Id: <1238406057.24972.23.camel@johannes.local> (sfid-20090330_114105_983781_83388221)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BSyDxkG2EU8AScMNqK/V
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

TODO:

 * toshiba_acpi.c
   -> need help, seems to abuse input polldev and report it as both
      input and rfkill block state? at very least need info about what
      hw actually does

 * thinkpad_acpi.c
   -> need help, convoluted code I don't understand at all, looks like
      another candidate for rewriting

 * wimax
   -> need help, seems to report rfkill states to input device?
      don't understand

 * b43/b43legacy
   -> compiles now, but should remove input polldev and use hw block
      polling -- later

 * tosa - done now in new patch, but not even compile-tested
   (http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-rfkill-r=
ewrite.patch)

 * test
   -> need help, I don't have any hardware with rfkill buttons, will see
      if I can come up with a uinput rfkill "button"

johannes


--=-BSyDxkG2EU8AScMNqK/V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0JOmAAoJEKVg1VMiehFYK3QP/AhjmB7+DecaZgkNazG1AGHV
03B+/q/MhRkQFDfhAYj3h/5M3J3st9VrGV6zUSpIXz2fUVWOPqaOLL5yUdWsZJYB
rXe2jycYTJcO98mK16X7QPFDVlMtXiyLXYnd7XYZ2/S+If19gmnoDi1i5S/1SI3a
ok9n2taCEHsRxoE/gtivO6KT/sHKlqxi1G2s+C3N5/VEF08n+9wW4pEzNsCjMpGy
yITcCWKbiLsevjGm8YcQR7oNqHojeeD0AjYlb/ZD/j/DMjIn+DUNq/r6R1qLP0JG
JK119g/GiTV9yYyR7MKidAm3l3DcH9f7IX7nnr1+h09o3Swe1BoFOV2TgnqDq4NB
XbY5YV8zeHEPBQv6xZ5VU/cwvUBUT6FkV6AzkYA70/61tkKjKGzTWXByRmpT6H+5
Q8rsYiTmLmr6Uz3c1zFcL29X1oz7lZlPpkPEskUe9McQTd7psAdVCpwLCAiR1Ry1
K57g+y0WN1HMd/LTf3eDqCh3kQ601OdFIJOy0jDzEynxZnxMADUodiKi31K76R2v
JzkP1S8OBoTrW6RO2SORdcLHuuK8e4N3vHav4JBpslbzywGz6RmCdD2zmzFfsUc2
5Uv/4chBB0OsMOY/c0y94uYktL5rbWZ03V/cEu9B2OGV9F295JnaCUosvwFRg4Sv
8EviqxGyWYGW58wfwR+1
=RaFu
-----END PGP SIGNATURE-----

--=-BSyDxkG2EU8AScMNqK/V--

