Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44193 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932935AbZLFStY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 13:49:24 -0500
Subject: Re: [PATCH 1/4] nl80211: Add new WIPHY attribute COVERAGE_CLASS
From: Johannes Berg <johannes@sipsolutions.net>
To: 8an@praha12.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <200912061945.53225.8an@praha12.net>
References: <200912061820.26320.8an@praha12.net>
	 <200912061822.54088.8an@praha12.net>
	 <1260122477.3461.20.camel@johannes.local>
	 <200912061945.53225.8an@praha12.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-m2sKwjuxB4EikFoWE0zS"
Date: Sun, 06 Dec 2009 19:49:26 +0100
Message-ID: <1260125366.3461.24.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-m2sKwjuxB4EikFoWE0zS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-12-06 at 19:45 +0100, Luk=C3=A1=C5=A1 Turek wrote:
> On 6.12.2009 19:01 Johannes Berg wrote:
> > This patch assumes that all hardware supports this, which is not really
> > what you want. You'll want to know if it can't be set. Yes, we assume
> > rts/cts can be set always, but that's a _much_ safer bet.
> If the hardware does not support it, the operation will fail with EOPNOTS=
UPP:
>=20
> # iw phy0 set coverage 1
> command failed: Operation not supported (-95)

Umm, no it won't, that's only with your specific mac80211
implementation. Try on rndis for instance.

johannes

--=-m2sKwjuxB4EikFoWE0zS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLG/yyAAoJEODzc/N7+QmaFIwP/0G3EWI9SEM/+9jlpI8wtNlq
fzSFTleeB5tw2yRdqEQZrrAAAjD4MBlOcMXXTAzIXNbyvIl2znlZYapSjNnnQNKv
vsGsdSPmJvKukFN6CKZUrBDXehRMv84/f+k4pcPIGWm2taEkLaBgkWGq6RXDnYFB
99PC4sp+xcEUSTXm6BlyPHLiMB1Ef22v+nLO2NKn3429Y/UUXVsjhvyq8EFm2zvg
GC6/FX3qRN6ELtIXDzCrZCee8A4IqhQ0HgEnK8TXVFhoMDeEJsJZULAWqKL8bFGE
sQVhRYRelxBHMk+kjvrtpQO9GYeB8FLD59mvQUcxb00dj8DenD6GpcFkfIgM8vuK
+P8WTNslF7pAWcJ5Iyblxi4gac1BrqfP5YYYg27GalHxAv9iZ4KHMlS8wHln2JHu
SEM1Wsr1LjAPv80q7Bp4iQRWIb6ysWLAvnK7DqyVCLIZkmKqom6Ob2G2cuulCmTu
iWzp+Cpgug6ynnbOalq9dbukkrlJDdBRNeeCZmVuvXDTVTk4LiVVnVCUQdnALTSI
H7aNKmssDG+XIGJ+aqKhUEICOgl0EDQPITmaqSs8MQgijDfKFFXrMSAFjH6zYVWE
AAAgRYn+og0zkgQyQ4evUt5QRn/fW7y3v1VLXwtY7WHuyYqvwI/6se1wvpfa5gcZ
RNsiI1i5b7zg9A7S4uyD
=xBhE
-----END PGP SIGNATURE-----

--=-m2sKwjuxB4EikFoWE0zS--

