Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35412 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbZEBVUv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2009 17:20:51 -0400
Subject: Re: [PATCH] add version.h to .gitignore
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241299096.4412.20.camel@localhost.localdomain>
References: <1241294826-27585-1-git-send-email-marcel@holtmann.org>
	 <1241298417.13562.26.camel@johannes.local>
	 <1241299096.4412.20.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5MJEQSZdTJL2dUyrbfRn"
Date: Sat, 02 May 2009 23:20:49 +0200
Message-Id: <1241299249.13562.30.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5MJEQSZdTJL2dUyrbfRn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-05-02 at 14:18 -0700, Marcel Holtmann wrote:

> > > +version.h
> >=20
> > Nah, just rm version.h, it won't be rebuilt :)
>=20
> my bad. That file was dangling around and I never bothered to check if
> it still gets created :(

Yeah, no worries, I checked the version scheme to something nicer a
while ago. I guess at the same time I also made "make clean" not remove
it, so you would still have it around even then...

johannes

--=-5MJEQSZdTJL2dUyrbfRn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/LkuAAoJEKVg1VMiehFYymgP/2PSlJf9IjNLdugI5c7/EWKm
uaqfQRkIXFI1/H80XMIdqgtxPzkZZvAvSIlJHPQNEeDE4/rSYlVL5HV7Pcrauyti
p3FY1JkrIDzc6znM4MnNXpGDSRYIYmGCOg49AoIyj6Tut/AHRadu2m9DO7zz6X43
6YVpPsoiM8AZaH6HNwLqwjdf/Tthd0kUSUhxpOcPslTKij8WfpNkPN8eav41E3BZ
DsHxiOsxwxKV9leNK1usb3cE5L2fYY2dCV9yLoALU+8cdT+jEcQZIBCY4jiYpaPn
XpNsQ50im3Ng/gjjgz8+Z+Age4SPsVehAPWmHuDiS+3yQ7grZD7M8gmd++mG5rYp
aRLL6fAGr7ERvtYSaQDyx0+Q22+24pQCQC0rHIiDrW0QwPua4teTcdlCnDVpH/2A
4e7V0bKWTTpTTACKFJNYHuNNfce/qhVSkF7Ehnl/zZnXa1d0gubZ1BH18M95ivYR
rN9YgGBpR8X0HUpH1Ji4oSIKCO7BmNYAv7kG4qvGtV0zdQVyC7kvche1Z+LBMXh1
zUPUcX0ssw+sHjYPDCB/T4jEwd/1DdRMisT6Hs5acDm+enm0nVFpTBg/JynWZeA4
/HnoMigURcuxb1hyFPS2vYV0lN395FYAFdhlumRXNrZh1rd0B4cc7n2xgw+/MO40
iLoUAZpkRxmJSyhM/aOG
=lNZ3
-----END PGP SIGNATURE-----

--=-5MJEQSZdTJL2dUyrbfRn--

