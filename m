Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36254 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbXJOJGA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 05:06:00 -0400
Subject: Re: atheros hardware needs padding for QoS data
From: Johannes Berg <johannes@sipsolutions.net>
To: bruno randolf <bruno@thinktube.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200710151800.36338.bruno@thinktube.com>
References: <200710121946.30024.bruno@thinktube.com>
	 <200710151241.17651.bruno@thinktube.com>
	 <1192438036.3349.16.camel@johannes.berg>
	 <200710151800.36338.bruno@thinktube.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ps3vAH7D6HOz5J6Twu0Y"
Date: Mon, 15 Oct 2007 11:06:23 +0200
Message-Id: <1192439183.3349.18.camel@johannes.berg> (sfid-20071015_100603_446346_16614851)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ps3vAH7D6HOz5J6Twu0Y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-10-15 at 18:00 +0900, bruno randolf wrote:
> On Monday 15 October 2007 17:47:16 Johannes Berg wrote:
> > > another solution i thought of was signalling the mac80211 layer that =
we
> > > need padding which could then just adjust it's headerlen. but then
> > > different drivers might need different padding in different places (i
> > > don't know?). what do you think of this approach?
> >
> > That could be worthwhile, though the headerlen calculation is called
> > very very often and adding another branch into it could very well impac=
t
> > performance worse than doing the memmove.
>=20
> now you confuse me. this is exactly what i attempted with the previous pa=
tch,=20
> which you didn't like...=20

... for the reason that you put it into mac80211 rather than the atheros
driver that requires this workaround.

johannes

--=-Ps3vAH7D6HOz5J6Twu0Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARxMtjqVg1VMiehFYAQIgsw//fm24D6p4lx4f4xmvjUg1EsPhUYjLUAwO
/yePJmEBLqN1PR9e/FsKWI75SnooK+hMwPP1QuRuZ/NG69zs6Tiw4UkT5bZbJUCe
2F77Zffxh4a3rt+y3luXXtbFjf2xxPo6I55CbNobcZfMeDYoidP9UXh3R4Kamna/
LbInT2FyrNIM3MqiqHn7jikbrr7rQ/+5dsYHW1QVQCX/OEnNs+Wwv5Us68E2FPXx
GJkgjTI8EdBNV06OTsDk1QBQ9JQpz+RQ0laWBp/3JuMaXnmQzem285xkMJtov4cA
075H9iNH8hq5UKVGG7PsaR/8l+Nq+iSNkdmmlOGdEeYVZSuVElbEVTB8F3Fa7FZy
onv63m4EUY+rpqQXVbtVR24FzYRFo9l2caN9tEmQ/WRY9f9I9GoaDPreNLk07MK4
UXLK3AGMsD8Ur/u0E58VVPYQi2Xd3Pfv1eLb4S7ATXkdwVSv8qK7ci/Ah4ad2UtG
NtnZiyWJWNXmXfyYVJS31anmsejKKuuXDqqbnivdUJIKn2urMtI52PNd25odWhBv
t+hemnWKPYFSZ8e+nkxRhCtGa4Neds7ghXV9xmOoBWdawMVxC1Ew7nwG8bDhBD3T
iP/h2FdI0E6ZZ3JYwbibUadf0ZlVIDw+bWOtkqjJZ2VnIUgsJFFXnSWhsPM2Db1W
K5Z6rgHvFVc=
=Ptym
-----END PGP SIGNATURE-----

--=-Ps3vAH7D6HOz5J6Twu0Y--

