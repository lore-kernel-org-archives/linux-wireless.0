Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39620 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbZLGG5F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 01:57:05 -0500
Subject: Re: [PATCH 1/4] nl80211: Add new WIPHY attribute COVERAGE_CLASS
From: Johannes Berg <johannes@sipsolutions.net>
To: 8an@praha12.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <200912062259.40177.8an@praha12.net>
References: <200912061820.26320.8an@praha12.net>
	 <200912061945.53225.8an@praha12.net>
	 <1260125366.3461.24.camel@johannes.local>
	 <200912062259.40177.8an@praha12.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-I3yLknDOSTtrsJRW79Y0"
Date: Mon, 07 Dec 2009 07:57:02 +0100
Message-ID: <1260169022.3461.26.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-I3yLknDOSTtrsJRW79Y0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-12-06 at 22:59 +0100, Luk=C3=A1=C5=A1 Turek wrote:
> On 6.12.2009 19:49 Johannes Berg wrote:
> > Umm, no it won't, that's only with your specific mac80211
> > implementation. Try on rndis for instance.
> So I looked at both drivers that define set_wiphy_params: rndis and=20
> iwmc3200wifi. Both ignore WIPHY_PARAM_RETRY_SHORT and WIPHY_PARAM_RETRY_L=
ONG,=20
> so WIPHY_PARAM_COVERAGE_CLASS is just another parameter they would ignore=
.
>=20
> Anyway, I don't mind adding set_coverage_class to cfg80211_ops if you thi=
nk=20
> it's the best solution. It won't change the netlink API.

Maybe we can just keep it the way you did it, and add capability flags
for all of it (retry too) eventually.

johannes

--=-I3yLknDOSTtrsJRW79Y0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLHKc6AAoJEODzc/N7+Qmaap8P/3PIGFtbrTzSsl+RmYW459AY
U635JOzMF3HNLOBEYRdxHnK4k62MrX6ZlZGR15t8ZmXuwJdJ+hbHDwTztTEae+VQ
UFAAr0Oyius2L+2nj+EtBBf6QGaKNaXF0Fo4J61X9lO6E4GMIvN5XqIhxsU8o9Gh
mRGfcJ7/TsZ2nZdYWW20dVYw2HlxSQ9bmpvBI46tcExFqUbFLkJu961v3vTb3f/3
mVl3GQFL8v4qNgJZkVvPzjPXO8u7KywiJSQE/stgnXRthyPO9qsj9CsUWRX5VKvf
LmuW8BACOWNHAxEIISp7xxJ4iMK20BU8xLq1HGpw68hIcKcaJD8UrsKZOxKdTNPB
NyE1Aj+OshjVTqqJrYGPKiUsk+owchQLLlAskL8j54U/2mkVLRC7QMDlQj/OF1F9
p0MOBCA30zzsQ/Msownn2w+HHC4ztPgs5o+7vspi1s3dE6Sc0eKw/LBL81wAOct2
ellXJvnZD8thwPilO/YDpYMbRz9oBhBlxa0rOIQs4a6AziIqtKY98NVPFIlXzyV2
luNgPGThrVCwSH1cMFLXdSq9mZZhc2ZL4qk51kRHG29O2coTWqZuJ39p3zLEDoCh
LCBDE8ThkRS98e/LkrwrQ6vY7IhgFptwKd7+GqutsFUn7Ka4aMPcmTwOLP4L4mh4
q8FRP5mS9W9rkr8bVpzk
=FKoI
-----END PGP SIGNATURE-----

--=-I3yLknDOSTtrsJRW79Y0--

