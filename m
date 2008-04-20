Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35352 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256AbYDTSm1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2008 14:42:27 -0400
Message-ID: <480B8E70.4030703@hauke-m.de> (sfid-20080420_194231_700808_BAFE865B)
Date: Sun, 20 Apr 2008 20:41:52 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: lrodriguez@atheros.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: compat-wireless-2008-04-20 doesn't build on armv5te (xscale)
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig810DA00DD6F96A96B60E387F"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig810DA00DD6F96A96B60E387F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I have tried to build the full compat-wireless-2008-04-20 for OpenWRT on
Intel ixp4xx Platfrom (armv5te, xscale), but I got the following error.
The parts before this were all like on the ofter architectures.
This was made with gcc 4.1.2 and kernel 2.6.24.2


  CC [M]
/build_dir/linux-ixp4xx_generic/compat-wireless-2008-04-20/net/wireless/n=
l80211.o
  LD [M]
/build_dir/linux-ixp4xx_generic/compat-wireless-2008-04-20/net/wireless/c=
fg80211.o
  Building modules, stage 2.
  MODPOST 37 modules
FATAL:
/build_dir/linux-ixp4xx_generic/compat-wireless-2008-04-20/drivers/net/wi=
reless/b43/b43:
sizeof(struct ssb_device_id)=3D6 is not a modulo of the size of section
__mod_ssb_device_table=3D64.
Fix definition of struct ssb_device_id in mod_devicetable.h
make[6]: *** [__modpost] Error 1
make[5]: *** [modules] Error 2
make[5]: Leaving directory `/build_dir/linux-ixp4xx_generic/linux-2.6.24.=
2'
make[4]: *** [modules] Error 2


--=20
Hauke


--------------enig810DA00DD6F96A96B60E387F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIVAwUBSAuOhYZ0px9YPRMyAQIYiA//b60kfxuVyLl3RzeEhiLkiwhOccAtFcjy
DmwBBR0AxuK8e9ReRttn7vnsW5eF2mqcrk0wlUhwTIbKnqd9A/MSt+KUDhnsXQ+c
GKRBHFKFO0UBxqUcaiikB1DsKZgiEYrrwJJnKWg2qs5AOpgbPFGK/RxGjhuUDzkm
DjyTGoZaZaFAC7dsIKjbNRRGBkMOOkpGtpcRgGK5rEJ/iRzATu7yQFeQWI6IVFvv
7YDTTq9UoizuO163JtvKcVvcAAzAS6O2N38sEbBC/T7ETgKnAESBetwGaM3eTmTC
a4gBFJR9CgY4LHcC8y25eKGEewUThJ1hSeVgUQlVgYNc8+2kJoENREL7Za1xN/Oe
rvXZJ4WZs84UlUOaFdBkHsyCPgmlfy5isgxInFuFjlbA3TAMOJL4fFGTsEnxZMe8
2U7tsIlt9UsMhSxqH14XIFpFub9FFm0NIOoJmpcCXqYXuJ52NiY8gLftG0T7Yl0t
bZoJSDrigKSm9I2p5MfzNCdoO/GBM7zijA2CI6Bto9MVmEYBeyiTg+kQCeb7islc
M719C3eY73P03at3EFrLWjWJ9ONMqow3ASKi6Uds1/eoYNF1YcBewbwriOavN8FN
ijjJnGCKEMkLJgTSyFRZYPasRI4YclVmg7SO/NSbKcC7kGFvCobLR4QuIS2XrRrG
g7sd1sJV/gw=
=AyGZ
-----END PGP SIGNATURE-----

--------------enig810DA00DD6F96A96B60E387F--
