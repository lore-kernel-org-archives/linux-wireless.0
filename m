Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52449 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYF1H5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 03:57:42 -0400
Subject: Re: [PATCH 1/1] mac80211: don't accept WEP keys other than WEP40
	and WEP104
From: Johannes Berg <johannes@sipsolutions.net>
To: drago01 <drago01@gmail.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <f6ca9fed0806272346y2e8fde2cwa27a79ee83d0c0af@mail.gmail.com> (sfid-20080628_084635_094025_0ACD0C13)
References: <1214610613-6990-1-git-send-email-tomas.winkler@intel.com>
	 <f6ca9fed0806272346y2e8fde2cwa27a79ee83d0c0af@mail.gmail.com>
	 (sfid-20080628_084635_094025_0ACD0C13)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-j8SE1liJZcA1Yqhb3r/3"
Date: Sat, 28 Jun 2008 09:57:27 +0200
Message-Id: <1214639847.5507.6.camel@johannes.berg> (sfid-20080628_095746_350702_95F5F2CD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-j8SE1liJZcA1Yqhb3r/3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-06-28 at 08:46 +0200, drago01 wrote:

> > +/**
> > + * enum ieee80211_key_len - key length
> > + * @WEP40: WEP 5 byte long key
> > + * @WEP104: WEP 13 byte long key
> > + */
> > +enum ieee80211_key_len {
> > +       LEN_WEP40 =3D 5,
> > +       LEN_WEP104 =3D 13,
> > +};


> > +               if (alg =3D=3D ALG_WEP &&

> What about 0 ?
> See http://marc.info/?l=3Dlinux-wireless&m=3D121458316301507&w=3D2


I don't think zero-keylen will have WEP there, will it? I don't really
know though.

johannes

--=-j8SE1liJZcA1Yqhb3r/3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIZe7jAAoJEKVg1VMiehFYTjcP/RatPkvcG4p9cMm8V8rkQ5v0
ymeotc56z2W0GiZk4eDqthp+/NP0ry05VcLPtQ2Fws6thyUphdvtcx1gQ+k1J1nN
vRIvkCDfKzN9PSzrUyytkR6XyEJ2AJahzShtX3K4XpE6RW+RudBbQBt/6A73x2R9
LrVK1hOV/xU9TZ+J5PrQZQ1VFjNOXLISvg1UR531XNxpYMkw7mKYVG/sRsfP3Uzt
CG6fUagpUL3LtqiBbmQoSm9+sPuW+1nnmQJzwu0urQqAkeFw796jUwPcR5jgcipT
xIATXNhI/oT17BWhs/5HlFy0mbmnIGbYV9jJZKNQhMO/rB7/Mp59XI30UnMSXm1a
qFEv1enEzSj+88CNygwuJjI3Yws3YFAB+klSLGRAeoF6MzUj3YdEMV/UmUEpeFiD
NGL9u/oYREcVo0gliTHdTkne89lSdw2C/0wEeR402Z4+ifS3PuJXbIrnWz+FxD71
HLlzp8C0qb3OAD3hR+2yi2v/x4cWoqvTa7OIZq4w9SIVNATyNdSCyvwxhFqyP3kP
M+TniplZyEUfbJgFD99oawxYQTYXZmown5CWIjvlU8gELduzMe05uZ91viKnEFKr
w9ktOXzozSXRnSiA4Oa8GmsrvCDIrRgLTfKjUwJN+tnMrMUgn7dvNEFMZNIBmxtG
txv2cMZh9qCWnCUi1ywr
=EmwI
-----END PGP SIGNATURE-----

--=-j8SE1liJZcA1Yqhb3r/3--

