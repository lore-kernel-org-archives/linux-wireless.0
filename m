Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39916 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbZDQTbY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 15:31:24 -0400
Subject: Re: [PATCH] iw: Add set/get for frag/rts threshold and retry limits
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <18920.55219.833341.713847@gargle.gargle.HOWL> (sfid-20090417_212340_384716_7A88CE07)
References: <20090417185041.GA17526@jm.kir.nu>
	 <18920.55219.833341.713847@gargle.gargle.HOWL>
	 (sfid-20090417_212340_384716_7A88CE07)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-s9t759B8YSsJ1bj+vXso"
Date: Fri, 17 Apr 2009 21:31:19 +0200
Message-Id: <1239996679.5110.13.camel@johannes.local> (sfid-20090417_213127_255724_7E89C3B5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-s9t759B8YSsJ1bj+vXso
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-04-18 at 00:55 +0530, Sujith wrote:
> Jouni Malinen wrote:
> > --- iw.orig/nl80211.h	2009-04-17 21:48:13.000000000 +0300
> > +++ iw/nl80211.h	2009-04-17 21:48:17.000000000 +0300
> > @@ -7,7 +7,7 @@
> >   * Copyright 2008 Michael Wu <flamingice@sourmilk.net>
> >   * Copyright 2008 Luis Carlos Cobo <luisca@cozybit.com>
> >   * Copyright 2008 Michael Buesch <mb@bu3sch.de>
> > - * Copyright 2008 Luis R. Rodriguez <lrodriguez@atheros.com>
> > + * Copyright 2008, 2009 Luis R. Rodriguez <lrodriguez@atheros.com>
> >   * Copyright 2008 Jouni Malinen <jouni.malinen@atheros.com>
> >   * Copyright 2008 Colin McCabe <colin@cozybit.com>
>=20
> I don't think Luis would complain, but still... :-)

He just copied the kernel file in ...

johannes

--=-s9t759B8YSsJ1bj+vXso
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6NkFAAoJEKVg1VMiehFY2DIQAJKR5pJFjbGWSsyXlTXvFYU1
7AMKqVtG+2S/29Og/Pp0yzbSyN1VQWE1Kj3RmvNmjKDgZIHJLCDEIQgKmpJrXyl9
X5/NY5bnE3LNc6GgQB84tbK6go2usONW/dPDRaHPR0w1zl+bOsYpa8iCQG9o0szU
bz4D8Mzx2FZHzAs99SSBPNoeCLfsx8NyMuhwDEKnxIZMxwbRRs/MgfsCJpmhP3GF
NbriSln4vU3kIVsQtEF2UrUjzeBeJIYCU7F92hN7px4Eg6qqNhzkuN5F9pW0X/hI
YU9+Hy6Aizyfcg6E0+mKND+0rCGlVcgTU2+UiIQEPSs6kqKp4tuNtvlbOESJ+/qk
ZO+sKIXKH4247CssFAilrmFDmR6vmhtMNtqTNkM+Nw88c1oZum2T0HpkO8XPX/++
tCPqqaWUTs3MZC8qP+RV1uNs79eSwReT1FRF7+LG3MPN1OWlUst2xEBkbX/LEorC
nfuM76WJrLbZsWfcvibjZVp6Qm0JV6W5kuAkhmIZUdt7SYw6vV+ilyZXkoDlULnv
liVm1ArLNUiG2mwES7vgi5JA9coG0W5Y/kKLDORWNF/DsU+JGND38BEHtNS+wr5v
zjV0cwmxjXzv/59AG8Wj1mYddt4tiJQNvAFvisJl8euek2cAJXi9XrF2ysyfr43e
EbU2rjD/fIzgJoLbGQln
=2VoH
-----END PGP SIGNATURE-----

--=-s9t759B8YSsJ1bj+vXso--

