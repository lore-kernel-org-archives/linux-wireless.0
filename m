Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36524 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbZFAMuO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 08:50:14 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090601124553.GE11011@khazad-dum.debian.net>
References: <1243524688.10632.0.camel@johannes.local>
	 <9b2b86520905310213n7be56260lc0c2cf3c109fe065@mail.gmail.com>
	 <1243763887.19302.29.camel@johannes.local>
	 <1243796509.6570.35.camel@localhost.localdomain>
	 <1243841639.5299.8.camel@johannes.local> <4A238EA2.4040106@tuffmail.co.uk>
	 <20090601122839.GB11011@khazad-dum.debian.net>
	 <1243859931.5299.17.camel@johannes.local>
	 <20090601124553.GE11011@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-iNAV/5MHpwgmlmrt3P5J"
Date: Mon, 01 Jun 2009 14:50:06 +0200
Message-Id: <1243860606.5299.21.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-iNAV/5MHpwgmlmrt3P5J
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-01 at 09:45 -0300, Henrique de Moraes Holschuh wrote:

> I mean platform devices which remember state.  Those will be turned on/of=
f
> by the platform firmware at boot and often at resume time, and overriding
> them in rfkill (especially if it is done later, by a rfkilld) will cause
> some flicker (on/off/on, off/on/off) in certain situations. =20
>=20
> This is a regression, because the current interface doesn't suffer this
> limitation.

Right, but that was already covered by the discussion and patch I just
sent, no need to complain, afaict? What's your gripe with the current
add-on patch that I just sent out?

johannes

--=-iNAV/5MHpwgmlmrt3P5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKI856AAoJEODzc/N7+QmahLsP/2PjpCBw0XId/OoY7X+Jiftc
uxzuX8ynhXTl+ceGtivZYTE1PwBHvcPUAL0HsgU8ZIv+oveKV6hYVO614qeM71Fx
zugOWiaY/ykll1LUgHYQHsHjWtFjNDhd16c7eI7Seof4J0ULYGsbFQb0ULXdPTnI
9ojGHVK4gX9p+4vCDXiFjKn0Cw3UF9Mb6vwNi2FtMZmUu4YnCKUKucfzWag9tkI3
dVkfpk5JIwXFf/LUG/ggnGHbWul6qFZwnljCMuZI3aiivZcwm4G0nI+c0W9N5R7a
i1or9nruM55DxhYElq3NzTZDIs3Sb7fr0msHS/teFFMwnua3cwdhbytncdAklGuA
CZZq6T1YLwyqtgDd7gAPivFJO+IhU2kerGhJykE0Iz9cvukK1mgebZJAKVTZV+Ge
yUjURF05H5Z4wvcu9q+2tt9FI07TVZhct0FZmIUKhEf60rqWMBb8OsA3IuSPuumC
8gJaAdX6Vd1ixSolMXF0UEAyfGXLU7jiif/MQTxPygL5Cv/sgR+4gBlojqnAfNC+
uvtYwrrpQY9vwlLaHwz3le5U1tw4gYdJ6K8ScRT1hOwFNQ8P9gJP/Sau4UCLQ8Nq
R+3ZtQRMxxu2hPmjPpeKhL+9F0J5IBxe84qIw6qDj3Itb/ta7SGTMa3wydoLGAWQ
fYIaHh5BwYU0oznUTBVg
=4+jW
-----END PGP SIGNATURE-----

--=-iNAV/5MHpwgmlmrt3P5J--

