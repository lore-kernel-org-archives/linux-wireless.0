Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56712 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab0BWRxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2010 12:53:33 -0500
Subject: Re: [RFC] Improve software scan timing
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@iki.fi>
In-Reply-To: <201002231744.39133.helmut.schaa@googlemail.com>
References: <201002231619.55189.helmut.schaa@googlemail.com>
	 <201002231633.06394.helmut.schaa@googlemail.com>
	 <1266939493.3934.8.camel@jlt3.sipsolutions.net>
	 <201002231744.39133.helmut.schaa@googlemail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-T6a/nDV6Ovb+Bz0zezzU"
Date: Tue, 23 Feb 2010 18:52:44 +0100
Message-ID: <1266947564.14410.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-T6a/nDV6Ovb+Bz0zezzU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-02-23 at 17:44 +0100, Helmut Schaa wrote:

> Ok, I'll just update the listen_interval to default to 5 and make use
> of it
> in the scan implementation. That should allow us in most cases to
> leave the
> channel for around 500ms which is enough time to scan maybe 3-10
> channels
> depending on active/passive flags.
>=20
> Would that be ok for you?

Sure.

(I blame evolution for the stupid formatting of the quote)

johannes

--=-T6a/nDV6Ovb+Bz0zezzU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLhBXpAAoJEODzc/N7+QmajPMP/1IHykxR9SKejW/vB7wQ51Zw
iBBjUb2UhKC2RdbRzZxuZHvkso3Vy8rh7S1wNm+ruJkuv1qLzthB01zK3r4IougP
WqBy4RVULCMbhXoRef1QIxVjch3lEOIq1qxrVSVIMzYrcxrsxA+Epev3HKBHHz29
3mDdRAJPPdSUVhT7OjN498TJSptwjk8OqBjTKOBMYN/+zulbmyu7RTIHW0IiDWMx
FCSpHwRJuVmRqCt19/TBgN8XopTK/xfDLx1mTGe25VH2FZ9MvAhFWVuaHkWT9vrW
GGJxngo4PjrTVMLi1qvwQlfqWMDzg7CoBrenYBwswk2K5Uj+Bdb7Fx8VFrFn3wxn
8r8Y6On8grSIvFUX3LBoAw7fEIjPSXr621WMg75Oi/WhvDnlp45i+GcxTEzcFM98
Mn/sIrvq3mMIfKBSf05LCqfGHYWAP/dHRIQ+/lUJOt0Mk2ZU6+Vl15hQbFq3ngk1
1cOrU9kM3JFs7PUmSNS0XD7BAoBG9d/cDgT1vPWoctr8eVDTDH1loeFWPxFa0ZRP
dFhCsf1DbYCWghyLTOQvBTHK4l2N8hSzYFA1wGa84EKtgk4Kdzm2bi5ywWRSSnmm
SbONYBX0/KC2/KpyD0uz1GBrD61liUx3uXkmnKxXYs/E+eyzYUSpfhm1B9EEt33N
tLCpP8tTKOnkcgUoR98g
=11xf
-----END PGP SIGNATURE-----

--=-T6a/nDV6Ovb+Bz0zezzU--

