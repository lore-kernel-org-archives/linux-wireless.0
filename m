Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47918 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751900AbYDUOmN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 10:42:13 -0400
Subject: Re: [ipw3945-devel] iwl3945: Disabled channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Brian Morrison <bdm@fenrir.org.uk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <480CA260.70506@fenrir.org.uk> (sfid-20080421_162006_486515_D95FEC5E)
References: <fuhkfp$mnk$1@ger.gmane.org>  <480C5AFF.5020005@fenrir.org.uk>
	 (sfid-20080421_101455_395583_495A4EE6) <1208785818.26186.101.camel@johannes.berg>
	 <480CA260.70506@fenrir.org.uk> (sfid-20080421_162006_486515_D95FEC5E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Epgzci5d0I192CEVw72j"
Date: Mon, 21 Apr 2008 16:41:38 +0200
Message-Id: <1208788898.26186.105.camel@johannes.berg> (sfid-20080421_164305_253653_50D02B2E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Epgzci5d0I192CEVw72j
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> OK, sorry about the naming mixup, you are, of course, correct. I have=20
> not really got to grips with how all these different sub-systems fit=20
> together. I also see that the mac80211 and cfg80211 changes that are in=20
> Fedora have not made it into mainline 2.6.25, so I assume it will go=20
> into 2.6.26?

It should, yes.

> >=20
> > Does anyone have that info? I can dig up the info for Germany easily
> > (the "Frequenznutzungsplan" is available on the regulatory agency web
> > site as pdf)
>=20
> Here is a link that came from the Wikipedia page I mentioned in my post:
>=20
> http://www.arcep.fr/index.php?id=3D8571&L=3D1&tx_gsactualite_pi1%5Buid%5D=
=3D232&tx_gsactualite_pi1%5Bannee%5D=3D2003&tx_gsactualite_pi1%5Btheme%5D=
=3D0&tx_gsactualite_pi1%5Bmotscle%5D=3D&tx_gsactualite_pi1%5BbackID%5D=3D21=
22&cHash=3Da558568045
>=20
> This document applies to the list of 58 departements shown.

I can't say I particularly care about France, but even from the
wikipedia page you linked previously it is rather clear that we cannot
define a "EU" regulatory domain because Spain and France are in the EU
yet have not adopted the "European" regulatory requirements.

johannes

--=-Epgzci5d0I192CEVw72j
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAynoaVg1VMiehFYAQKeNxAAuSrC8agC/0iQZU4WAla0FNdMBDrR5m5p
h5zVzervXLrctZKuhMtGF+BSJ+bqOjXXeonQDaWmaoNXBMkmgQvTjKbRcYoo2GTx
ZxULpL6gSL9iTuPt7kI+BFnuCvl/TtzeytHK1ThMjAqRnRZCp8KrXC8gwvxxisVC
1oRT1sLR2nv9MeH8P8z4rKhWtHtV16v06mxdLwYm1gCqjshU6CWXSJOpE/j3PpL3
K+sLQUDQDG4WzdYX7ycWFRCDC1RC/nsozPCq+Zzf5u/udwzE6nHSYYG9RBWT+zuT
qw5QNCCTC3OQVkXfnsETs1do6gCkoTAMj0Blo/E+u2o7l7Ba1CLQujmc21m9U5rx
WnBwrKVYhonQ5DLr6X89fYs6yIISt7okuO5BLQHIxE8sL+OewxAbhjs6Ra7lkhQK
B9cHONPnZtZqBnRe4/3F7UurIFlzxCeiw9L6X/Lj768btDaa70wp/zrcr4NQGkX6
qikpp4AsEJXJwdVAFlKKUQfBrcBnmLbaAMaXMU9//V+3r1hn8g0VTGzDKi6pfSmY
c08OLRgxXj3C/JJkig7fOk9dcPlNnL929aGoysdKDxxF9OXD8Tty/tKG19TTj501
jbscZKACqSA6HFi7hgr7GdNLvpO2F/jrUJ/q587MF1hanHdCpxwoVx4NqucicCOE
xYdwD5YHHm4=
=l8Mh
-----END PGP SIGNATURE-----

--=-Epgzci5d0I192CEVw72j--

