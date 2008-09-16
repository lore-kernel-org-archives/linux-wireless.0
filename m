Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59129 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYIPUhy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 16:37:54 -0400
Subject: Re: [PATCH] Use the kernel source tree for includes, not the
	kernel build tree
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1221597296.17084.4.camel@dv>
References: <20080916200828.13928.55864.stgit@dv.roinet.com>
	 <1221596322.9262.7.camel@johannes.berg>  <1221597296.17084.4.camel@dv>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-i1kpqfw0bdrYHYb+2aJA"
Date: Tue, 16 Sep 2008 22:37:02 +0200
Message-Id: <1221597422.9262.14.camel@johannes.berg> (sfid-20080916_223757_171246_FE443F37)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-i1kpqfw0bdrYHYb+2aJA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-16 at 16:34 -0400, Pavel Roskin wrote:
> On Tue, 2008-09-16 at 22:18 +0200, Johannes Berg wrote:
>=20
> > > diff --git a/Makefile b/Makefile
> > > index 74cb1e1..9e79381 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -6,7 +6,7 @@ INSTALL ?=3D install
> > >  PREFIX ?=3D /usr
> > >  CC ?=3D "gcc"
> > >  CFLAGS +=3D -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-st=
rict-aliasing -fno-common -Werror-implicit-function-declaration
> > > -CFLAGS +=3D -I/lib/modules/`uname -r`/build/include
> > > +CFLAGS +=3D -I/lib/modules/`uname -r`/source/include
> >=20
> > I'll remove that line entirely though.
>=20
> In Makefile?  Please make sure that .config remains optional.

Yes; we actually ship nl80211.h out of the kernel already. So if your
installed kernel headers are new enough, you don't need .config, if they
aren't you might need .config, before you had to have it always anyway.

johannes

--=-i1kpqfw0bdrYHYb+2aJA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI0BjqAAoJEKVg1VMiehFYtUkP/32LE7uJlq7SGH1/+s1CGpk1
KZq7sXRsSHnTw27HQ/Y2x3kPyXv48Y6AN6gGR1fLaQbhHZZnRfshcNAqy2ujP7LY
MO6vGYUoiCqgld7WYzr6BVhUmZqy+1yodZ/yGL/XqHsEMLBbCJg/VfjLrSkmeqqJ
LueaUwYCDZnC5qOK1CfuxHmRoG3N77taLH9lyPhRHedtLAo1nO1q8/LZco5Z7GJ9
psmxS5JwiFigcj712DzkXguY3OVHwtzNffxMbhPL0svqyCPCy1DlGj+XXBJUB6Rb
JRwKAolejAdPXmfKqUTAiWBj3f6VDRb7B9+IvkdZjyDnlxr67yidd9wSvmAb17od
hXHqDaLe67411HKF9wv5zsNU6Ffe2M5efXWsBZcLVI8ona4zYX67QulZO0JfJ4Kc
iml9GgWriNg4XK2ycMp8A02Q6kIi2fqr8bPLTbuvDi0wR6SrR6bDgQqZraR2Mipo
ZmiLSdSi/FYSbhVLYalxGhGefTEMouYpixmkTflXhnlsbkW8iC7Sf5502udwY7ss
F8c7D4ZATJh3X0FKkNXSJGtFSYwVBkvK4P/6V5hJ72OdXJh+mf0Axt3CTmLmRIIE
25mkWaQfWpTQ5BYYmUW0YVxCZ8j3+SBTWoqhEwGSUL8qN5cyldDHZoO1NT5TOgM2
g32N2Yrng+jUa9CFxaE7
=G2qO
-----END PGP SIGNATURE-----

--=-i1kpqfw0bdrYHYb+2aJA--

