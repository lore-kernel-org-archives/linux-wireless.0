Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:34859 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbYDTPz2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2008 11:55:28 -0400
Message-ID: <480B6117.3000201@hauke-m.de> (sfid-20080420_165531_570329_F6F9D5A8)
Date: Sun, 20 Apr 2008 17:28:23 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: lrodriguez@atheros.com
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: compat-wireless-2008-04-20 doesn't build on kernel 2.6.23
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig57573A2D736AE5D6B6B36306"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig57573A2D736AE5D6B6B36306
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I have tested to build compat-wireless-2008-04-20 on kernel 2.6.23 but
it doesn't build. I got the following error:

  CC [M]  compat-wireless-2008-04-20/drivers/net/wireless/ath5k/hw.o
compat-wireless-2008-04-20/drivers/net/wireless/ath5k/hw.c: In function
'ath5k_hw_attach':
compat-wireless-2008-04-20/drivers/net/wireless/ath5k/hw.c:346: error:
'struct pci_dev' has no member named 'is_pcie'
make[4]: *** compat-wireless-2008-04-20/drivers/net/wireless/ath5k/hw.o]
Error 1
make[3]: *** compat-wireless-2008-04-20/drivers/net/wireless/ath5k] Error=
 2
make[2]: *** compat-wireless-2008-04-20/drivers/net/wireless] Error 2
make[1]: ***
[_module_/home/hmehr/compat-wireless/compat-wireless-2008-04-20] Error 2
make[1]: Leaving directory `/usr/src/kernels/2.6.23.15-80.fc7-x86_64'


The next error I got while building was:

  CC [M]  ompat-wireless-2008-04-20/drivers/net/wireless/b43/main.o
In file included from include/linux/input-polldev.h:12,
                 from
compat-wireless-2008-04-20/drivers/net/wireless/b43/rfkill.h:10,
                 from
compat-wireless-2008-04-20/drivers/net/wireless/b43/b43.h:13,
                 from
compat-wireless-2008-04-20/drivers/net/wireless/b43/main.c:45:
include/linux/input.h:933:1: warning: "BIT" redefined
In file included from include/linux/kernel.h:15,
                 from compat-wireless-2008-04-20/include/net/compat.h:5,
                 from <command line>:1:
compat-wireless-2008-04-20/include/linux/bitops.h:7:1: warning: this is
the location of the previous definition


If you need the full log please mail me.

Hauke


--------------enig57573A2D736AE5D6B6B36306
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIVAwUBSAthJYZ0px9YPRMyAQJN/xAAg4I+1vljwBo850PYQmUhlYL5s2VUn4Pt
FiruBiVjF98A2ppC8Zor3/8wroMQ90UHL531rmFqBDiYsNdxaIGva/C3nNWeFyj7
70B8LbHBsHcz1fmpuk70JdjL4VZbvni7pSAZxlzwCz/ZdnVVZSui+c9LW5GTH4OZ
nCFx88JF2LP4jkmBgAbnWO6BuAzQ0XAxwUYutV90dlsD0mhjqeTQq1xDn21eW5D8
ZjjRPq28j6q31j1k1KcG77u/EMwqwk1tHWXrQTvO3uow7BP1y2VGB0nMNTkKbkcp
5Mo+g8XwZRPNE9mC8udh1T5dWZB3iZstMWqaQY+Jz8Aze46M9pWVA6mXTUJVZ3zc
YD+cvqaQ8kdp6qnn50oDu9PQb/AnUIF3wqnrfwmLpiJW5f2xOiOr6zdYiHZXuqWB
PYvAqLOJWnw+o19b5MMHvhzEZs1UT9uxDEEJ0uA28y9iUkbIsgEqp29sdOS/YnXO
3GDQdCrloOCctg2qgeMgQkHGYsgiFRDRnOCOYCYfD3edoBelzm3uoWUPjpQIba4p
tMEPvkq0pwA6UTG/vOqGQQcTqffUmUO/6kvkFSkLsPVByp7m2c7XJ+NVh1tjee1t
esX9VpM2j2TevD6qttMtPOl54lulWRT54GVsM66qAlNYBvqgZal6vWx3fBbT0uqB
35BF/SNcdG8=
=xbWJ
-----END PGP SIGNATURE-----

--------------enig57573A2D736AE5D6B6B36306--
