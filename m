Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36360 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932618AbZHVHws (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 03:52:48 -0400
Subject: Re: [RFT] ar9170: use eeprom's frequency calibration values
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200908212252.41053.chunkeey@web.de>
References: <200908212252.41053.chunkeey@web.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Bjk3F1ez9w8Dv3hu68qv"
Date: Sat, 22 Aug 2009 09:52:47 +0200
Message-Id: <1250927567.23605.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Bjk3F1ez9w8Dv3hu68qv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-21 at 22:52 +0200, Christian Lamparter wrote:

> Johannes, in phy.c (now at line) line 429
>=20
> int ar9170_init_phy(struct ar9170 *ar, enum ieee80211_band band)
> {
> [...]
>         /* XXX: use EEPROM data here! */
>=20
>         err =3D ar9170_init_power_cal(ar);
>         if (err)
> [...]
> }
>=20
> do you still know what EEPROM data is missing here?=20

Sorry, no, I don't remember, and can't seem to find it either in otus
right now.

johannes

--=-Bjk3F1ez9w8Dv3hu68qv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKj6PLAAoJEODzc/N7+Qma5sgQANCE++jrPMd4vKPFSI984CnS
yHbGiROSt+Ttqh+q0PceH2EB2gz4BDYClyOIcu7tcRu32E9UG3e/jmOHWd5BgCEe
J4DDUsvYjCNHUFDEs9b2W3aZN5Bd5c1OwQfkXhTpdZj3chGYWm3e5GIOPVroUk0D
qmB9Uhkcit6PvHgrYcFuJxuV1xFdNLdz+Q/KGb5X+IAWWMhw9OdBtLzUiFsxtKgI
w6BaoNUDF4h1VKJcoQMAYhoC7lZSwpWioj9U7V/JyB5mdtDQ5nFqlv+fmj6mv+e5
Xm/les4yVfHZxzqZgxXHIRQ6TAndOYGd5GKw3FjEmzbntQstARhCm5gShLNoNsnl
xoh4ys/IyV+eX7Jo+CvCH8hqHJh7BbZtJWJeoCDEk8TvrVCRV3DBosGibFhGGhjs
/8t1tlybFdiMHiny6GTcyJbuLgJa1+8P2gFd5vpXr5s7+qFPpKQ7Lgzs+X7DGlF7
+2TfuQ7/Wh9rosAH2D0jYYtgnKFlxIb/Z8yntoyGU/sdzWO0BJj0FbsMeKKkQWm6
ixTusHisf4Rr25/R/B9lox0ZM3pvzZsZaED4mOJ8vVJyZ+nHrd6GwVEYhwwQUY7z
DRD5XrBIFjWjUlbEZWJFMovLnN2RkD0Z08QGJ30efLkaRNKZCKLEd8fDzRbWfecn
37q5PthEaWz3J2qCJlEe
=kiK/
-----END PGP SIGNATURE-----

--=-Bjk3F1ez9w8Dv3hu68qv--

