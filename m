Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47503 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbZFCLIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 07:08:18 -0400
Subject: Re: compile error: compat-wireless-2009-06-03
From: Johannes Berg <johannes@sipsolutions.net>
To: Bringfried Stecklum <stecklum@tls-tautenburg.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4A26593B.6050704@tls-tautenburg.de>
References: <4A26593B.6050704@tls-tautenburg.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-W52IIplkWTX13mP6FPQy"
Date: Wed, 03 Jun 2009 13:08:18 +0200
Message-Id: <1244027298.2650.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-W52IIplkWTX13mP6FPQy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-03 at 13:06 +0200, Bringfried Stecklum wrote:
> When trying to compile the latest compat-wireless package on an Ubuntu 8.=
10
> 64bit system running linux kernel 2.6.27-12 I get the following error
>=20
> stecklum@extragalactix:~/System/src/compat-wireless-2009-06-03$ make
> make -C /lib/modules/2.6.27-12-mygeneric/build=20
> M=3D/home/stecklum/System/src/compat-wireless-2009-06-03 modules
> make[1]: Entering directory `/usr/src/linux-headers-2.6.27-12-mygeneric'
>    CC [M]=20
> /home/stecklum/System/src/compat-wireless-2009-06-03/drivers/net/wireless=
/ath/ath9k/hw.o
> In file included from=20
> /home/stecklum/System/src/compat-wireless-2009-06-03/drivers/net/wireless=
/ath/ath9k/hw.c:20:
> /home/stecklum/System/src/compat-wireless-2009-06-03/drivers/net/wireless=
/ath/ath9k/ath9k.h:469:=20
> error: field =E2=80=98ops=E2=80=99 has incomplete type

That's rfkill, not sure what to do about it.

johannes

--=-W52IIplkWTX13mP6FPQy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJlmfAAoJEODzc/N7+Qmaj74QAIgANJtGs5Tzw1SKMi8+F9CN
C/4SsgdNNwM5bwcZeg+dwfv7cpGKpf0JWRaa2RYfl7bAtG5Y49M7wyeLSv6FAAYO
HSCPLHgEJKFFjEYINAprqyeSGmgHNARRxGmbkMBPC3TiGNt1NKAVB78yseaVotK3
OGFVEfkFYOsfGBFIvvtwimQ0WGMn9lt4i+Y31+G5qWUVuAJGrSV6yYDdNFrJpN2K
KGjXxKTfRO4NZlD+f6QAvR3rhCDRIyFrsKv8VZtIZUIW+Xg9fR54TRhnoggovU+T
SHzTAXN3MN0raWpYOs2S24wfMa+PMwNX+h11nFyfk6CZ7UjqOCbL+REEXdUx5P+v
Gx8j1OfLin/k1+pM39vChHYv/jWs3mHZVQ7TDsjr2MwuBqlNVBAhfWaS7Asz1+Ct
VnfNI2pO7KF8T124m85HwQ2V7a6dtUhDnfcPInYHA/KfVQ0QZwyFDsdWI7oliNYU
sLnUQgSWixH4fM31Kh4A6i72Am9uqgu8OOva3wrlC6hxeADeLYMyGmvGomm06rYY
YGMx3XEKWIZ0rILNsxhk8pu4aNcz1eyWMCJOONnBkBckoqIKRd1Cgf7U7NXCvkiS
jfLiIRHmOyU8BBI4KrLUqUAT8iesf9JxYVrW0JEM52aDPqNDGH6v0vv7tnlKM3/J
P6i6oPSaIU+1aahpBZ33
=M98r
-----END PGP SIGNATURE-----

--=-W52IIplkWTX13mP6FPQy--

