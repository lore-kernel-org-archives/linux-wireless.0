Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36978 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759531AbYDDOao (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 10:30:44 -0400
Subject: Re: 2.6.25-rc8-mm1 -- INFO: possible circular locking dependency
	detected (while using iw to debug a wireless issue)
From: Johannes Berg <johannes@sipsolutions.net>
To: Miles Lane <miles.lane@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>,
	Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0804030741jc9c7aebx21a7635e827b190f@mail.gmail.com> (sfid-20080403_154132_439220_5408BAC7)
References: <a44ae5cd0804030741jc9c7aebx21a7635e827b190f@mail.gmail.com>
	 (sfid-20080403_154132_439220_5408BAC7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bKvt2q+Ohl1u1gzhTYLa"
Date: Fri, 04 Apr 2008 16:28:12 +0200
Message-Id: <1207319292.19189.18.camel@johannes.berg> (sfid-20080404_153056_665880_D2147C12)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bKvt2q+Ohl1u1gzhTYLa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-04-03 at 10:41 -0400, Miles Lane wrote:
> After collecting the wireshark log, I found this in my messages log:
>=20
> Apr  3 09:22:12 whirligig kernel: [ 3987.336200]
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D

Can you resend that without line-wrapping?

johannes

--=-bKvt2q+Ohl1u1gzhTYLa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/Y6+6Vg1VMiehFYAQIhfg/7B2fVEGddw/x7OG7w6XtVvf45rnmwC1Zi
dfbOceH6GcG/1kVy8uXLrgbDBSkj2RXGt2YvsxuZDCMpR25P8VH6cbwhgplfTzpP
srXFANFOnOi+KgYbGAn8TH/Ff03lx9mL4BZtc2t04a7nI7Hp11xws6ILzLnLseSo
6WWSjfS+ujUg/PjspMMHx1AfjoI//WMBafE/eZSvtMwNjXrMRPHhxfIJeqV2StD4
9ARiDDEf/eJZguwgJcjkyhaUtQzREzGpPcHoBhrPV2NhZC2U9fZtcxXDmjQ4IC5x
VIOddnB8M5Zebd18nQ8zVDcQlxKJ0QjD0SaPkjmL0ztsKqXR4H9kfoZMhGEI52xm
OAmz1JUBzBR2VhLIhwoGA+dBhkFDdOJhJPCqj/UJJ5xjOxe8p86XKPdyBMC1qnEF
NoJNtYYbR3V7OjNMtOZjcmhCkIk0NFlu8GrL1Z9hAqPcNKosU90gTuQARRZUQlOt
arpdvhkoQRMK+K4sXzM7qnM0o/52+AWFSXwE4m/FZd1wr4fPzBtbLQufyriWOc/v
WKmtDSizBGmzQvUXmeO7RnOtCH4ocRxpUDRLJ5ma2qbjeyZOTrgu61bU2i54xKGx
pll83iwWhQkCsPMjmZrtvmDyVCe5zSbcdl616Xk6Bt7NTcxysWIIco8YBtiQHgZe
EISpuWAE1kA=
=+asd
-----END PGP SIGNATURE-----

--=-bKvt2q+Ohl1u1gzhTYLa--

