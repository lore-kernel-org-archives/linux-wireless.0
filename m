Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42126 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbYJ1IMs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 04:12:48 -0400
Subject: Re: rtl2860 driver in mainline?
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Thorsten Leemhuis <fedora@leemhuis.info>, Greg KH <greg@kroah.com>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890810280102i3df34e2h9bf281c5d1e00a48@mail.gmail.com> (sfid-20081028_090258_690109_8388E0BD)
References: <20081028004915.GA3442@kroah.com>
	 <4906B944.4010105@leemhuis.info> <1225180598.3796.66.camel@johannes.berg>
	 <43e72e890810280102i3df34e2h9bf281c5d1e00a48@mail.gmail.com>
	 (sfid-20081028_090258_690109_8388E0BD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-G0WvHuWQngdbYiOS01Fz"
Date: Tue, 28 Oct 2008 09:12:42 +0100
Message-Id: <1225181562.3796.76.camel@johannes.berg> (sfid-20081028_091253_144159_C9B71CC0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-G0WvHuWQngdbYiOS01Fz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-28 at 01:02 -0700, Luis R. Rodriguez wrote:

> > I don't think it makes sense either, at _best_ it'll do nothing but hel=
p
> > a few users [1], and if somebody actually starts working on the vendor
> > driver because it's in staging that's actively harmful to the real
> > driver by diverting resources away from it.
> >
> > johannes
> >
> > [1] I used to think the point wasn't to make users happy but to make it
> > easier to work on those drivers, but that objective seems long gone
>=20
> Problem is distributions already ship crap anyway.

Well, yes, but that's fine, it doesn't mean people will work on the
crap, it means people will use the crap. As far as I understood, putting
it into staging was supposed to mean "here is some crap for people to
work on", which is a huge difference.

johannes

--=-G0WvHuWQngdbYiOS01Fz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJBsl3AAoJEKVg1VMiehFYNvEP/Rw9Ju0mmiw5u5+NLH1H7oSY
c4TpCchoJ0My7unwO3lNHyytcmMFvMHhEoLyfKa7VaUK8QMoLbet6HSBulta2jSb
v1Hft+kSI8iwQRVJWLy54/+mxW/NCTH4ZwINODST1kXAd4N35luztZal67lUM4Qp
jSinsebQnxcZFrPJgW0T6oCoGHmxRxMdY07UF96QMu+hL5r9oCSNMyqGQP84Rdsn
gAjss/t3OrtPgyA5fTbs6jveDqfw3hJ9YNB50Gk2KpQWh/hM6xLjdeXNzyRAxDRJ
sqhAWvDaSvaqNAkjBcjkeQGQL0RpAYefdcsWYn78S5caGhTYMYWWluG9tbcrGXJ6
/+MnaLQaEOYTwdyc8PIdOCaaoL9H9DtILQJnRL19HVgf3Jt4buP837TvKxoTMwir
ZBgxG9uHMi9VrtTAY460wEfS8hw+SMO7H9srcIakAD0DAHRnpXWeqxKGG0VxeswC
kx9sxIxWNMOSqM8ml3PUATX6qdXT+qhC+HOJYAdLTTsUCgkRJcPOlPJ2l+e5FBG2
Zjg6Z7vATNer9AtZ9ynSlJHPUJP2BCpQdn8SemZwpzIWTMWnpo+P5FfACiCZJ/pG
yrC6+f48nOE1FeuAzAqvFy75r1LecQsi24ja5pm2TUOBkwNl2ARU/qa1sskwytIl
9O2qKIeLm3bbxXNObq0R
=0IIz
-----END PGP SIGNATURE-----

--=-G0WvHuWQngdbYiOS01Fz--

