Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42013 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbYJVTlg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 15:41:36 -0400
Subject: Re: [PATCH] wireless: update regulatory sample code
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: John Linville <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20081022123505.GI6190@tesla>
References: <1224701752.30459.53.camel@johannes.berg>
	 <20081022123505.GI6190@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+aa3eTEo0d6mIKNqgAPf"
Date: Wed, 22 Oct 2008 21:41:28 +0200
Message-Id: <1224704488.30459.69.camel@johannes.berg> (sfid-20081022_214138_940845_16F229FC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+aa3eTEo0d6mIKNqgAPf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-22 at 05:35 -0700, Luis R. Rodriguez wrote:
> On Wed, Oct 22, 2008 at 11:55:52AM -0700, Johannes Berg wrote:
> > Update the same code for the recent changes. I did this as a
> > separate patch to avoid removing a lot of sample code only
> > to add it back again in the next patch.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
> >  Documentation/networking/regulatory.txt |   19 ++++++++-----------
> >  1 file changed, 8 insertions(+), 11 deletions(-)
> >=20
> > --- everything.orig/Documentation/networking/regulatory.txt     2008-10=
-22 20:51:50.000000000 +0200
> > +++ everything/Documentation/networking/regulatory.txt  2008-10-22 20:5=
4:12.000000000 +0200
> > @@ -131,7 +131,7 @@ are expected to do this during initializ
> >=20
> >         r =3D zd_reg2alpha2(mac->regdomain, alpha2);
> >         if (!r)
> > -               regulatory_hint(hw->wiphy, alpha2, NULL);
> > +               regulatory_hint(alpha2);
> >=20
> >  Example code - drivers providing a built in regulatory domain:
>=20
> Should we mention how currently this should be avoided unless
> your regulatory definition is also intersected with hw capabilities
> and that the same channels are the ones that are registered to cfg80211?

?

johannes

--=-+aa3eTEo0d6mIKNqgAPf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/4HlAAoJEKVg1VMiehFYtI0P+gOnfCYt+DRI4HJXPp4MdNKj
ztiHsyPN1WFFCdtKRIxgFVSy3GYjJVqY745K3465iNuXkArrhGLeNkMFIyQLAWys
AiUDBJ+JKaABc8Y8F0iNGj/LzGdFJ0gOk8nP1Fex9lDNzbMaaf+tKuMwTn5wamS5
eFSV1zXZ88o+dMqh4qr1FAeL7uH8B5WQQSk7Zzqq7r15+d1tuyjtdbDWEP6d/kxS
FU/gX3K53GuniFEILeYDMCS0mrGx1S6J3haAvYqqbV8GQNUtkuM7BBlJWIn0MLTn
QCLnRBVKFcFLT0pgP0+mUhOHNH9XMtIaXxothIuA0j6mJFIBFwmXFCPPzOGUW06b
ha0HZC7SoBqED0SE2yw3cDjK8fmrvUl/h/m1OiryuKQ3nhl4+bCc+zHRKbzJMhzB
4tdZwC1n8EqxuHwTZQpqqVKSAL1Fi/95qLAipcUPcR/VvQtT8fK8JtIkfll20BY0
5I/jj8SdluafalXuTrL5GUtyoDGhZG39dkMnsG5o8tm+bb0vqyYI9tWz/l5aR+vn
aYEqIi9HxbKJEyWkWpNp9SvOZpVgmHdMMllRvvYenLpFxXY5JiXH9wnbScL7P9vb
565Kh0k4U+2ym6uPuJAdkVTjyW4Qo5GvU+wWc/vUJo20dhzqt2DN7lK+DAci9uXk
6U+kL6v6lg+NceTmYUtz
=ob1Y
-----END PGP SIGNATURE-----

--=-+aa3eTEo0d6mIKNqgAPf--

