Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50825 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbYBEKQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 05:16:06 -0500
Subject: Re: [ath5k-devel] [PATCH 5/7] ath5k: Port debug.c over to the new
	band API and enable as build option
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: bruno randolf <bruno@thinktube.com>, ath5k-devel@lists.ath5k.org,
	"Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <47A834EC.1070503@gmail.com> (sfid-20080205_100539_303861_AD604418)
References: <48232833e8885012a94d1e4afeabfd1deca9f70f.1202092325.git.mcgrof@winlab.rutgers.edu>
	 <200802051901.23454.bruno@thinktube.com>  <47A834EC.1070503@gmail.com>
	 (sfid-20080205_100539_303861_AD604418)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GmpsigusXFndgtBU1Sx8"
Date: Tue, 05 Feb 2008 11:15:44 +0100
Message-Id: <1202206544.4395.22.camel@johannes.berg> (sfid-20080205_101612_130417_2049C64E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GmpsigusXFndgtBU1Sx8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >> +
> >> +config ATH5K_DEBUG
> >> +	bool "Atheros 5xxx debugging"
> >> +	depends on ATH5K
>=20
> To avoid this for each config option, it can be closed in
>=20
> if ATH5K
>=20
> config ATH5K_DEBUG
> ...
>=20
> endif

And if you have lots of options, consider an option-menu.

johannes

--=-GmpsigusXFndgtBU1Sx8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6g3T6Vg1VMiehFYAQL8Iw/9FTd0ZvFRLBA/Ylykd5EMn2+KXJ7Vj0kG
xSX/CE1C+DTglmXha1pMvJEvj5zuXidDsnAqjnmqlyFo21wXagIWIRcJykKLQzNH
5kx9KrZ4J4UNrogUY7Z4BljBHziGf7IhDfCEx3kcwbTSiDktVnxRQBKta4SVsfQx
Hc/7D2SFhrvGzL5P2kCzxxB+EUDRbugdV8ieZCXdDO0FxJ71lJK5sTDuzwtkx2JG
yIAzgIPCRxQt5neYopAJqME4Mmlg0TYtGA6lhCyoLEGA7c9k0TsdAv3DiUD29Xrx
Fkiv3Y8qcoh4uL1x/QtZ6MNcEsqct1QQukJbkfqHPh46hKIKjIop0/lu5+gz6jrO
5cfkJC0cbPtjIhhTlQxuZM7nWWNygdqSKQ8BW7e+0wD1GCUiv/EfVS4Lb1Rd3le4
h00ZQzoANIDufbVM3Yhji1Fq7N2FPC4E+kcKTnLDE4QTpY4rJfWw5O6JAE7z076F
tq5T6/6Ujzf2IZV5scbnUGsqMw+t8p1uFrXpFd+o21CgZ4Q4CLXmD7w11JAPox9n
0guLXC7X1d1wtQ9Vk+zNm9xXUpkKAjfkJ1wlAoTxW1gb/UAPCwVhBq+oGUWpJkQv
fxkYiU7e2f6Uu9sV4rBqKevsUCLYjPAfFlagFjNv8dXrAHjAxKyyi0YCbskzFaW8
ug2lOFoPtkU=
=jI/T
-----END PGP SIGNATURE-----

--=-GmpsigusXFndgtBU1Sx8--

