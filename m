Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47840 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbZGWSAD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 14:00:03 -0400
Subject: Re: [PATCH] wireless: Compare ethernet addresses by unaligned safe
 way
From: Johannes Berg <johannes@sipsolutions.net>
To: ivan.kuten@promwad.com
Cc: linux-wireless@vger.kernel.org,
	Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>
In-Reply-To: <4A68A465.6020501@promwad.com>
References: <1245149672-18063-1-git-send-email-yauhen.kharuzhy@promwad.com>
	 <1245150895.8623.3.camel@johannes.local>  <4A475F82.9040007@promwad.com>
	 <1246262320.5947.3.camel@johannes.local>  <4A68A465.6020501@promwad.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LuIxMwf6E38sGSKyeFFt"
Date: Thu, 23 Jul 2009 19:59:31 +0200
Message-Id: <1248371971.634.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LuIxMwf6E38sGSKyeFFt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-23 at 20:56 +0300, Ivan Kuten wrote:
> > On Sun, 2009-06-28 at 15:18 +0300, Ivan Kuten wrote:
> >> Hello,
> >>
> >> In net/wireless/scan.c : cfg80211_wext_siwscan there seems also unalig=
ned allocations
> >> for creq->ssids and creq->channels. Should it be something like that?
> >=20
> > Seems alright, but there is more than one instance of this, maybe you
> > can make a function to allocate a scan request properly and have it be
> > called from all the places it's needed.
> >=20
> > johannes
> >=20
>=20
> Hello Johannes,
> Can you point to that multiple scan allocations? I see only one kzalloc
> with followed possible alignment violation - it's in cfg80211_wext_siwsca=
n in scan.c

I'm sure there's one in nl80211.c too

johannes

--=-LuIxMwf6E38sGSKyeFFt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKaKT+AAoJEODzc/N7+Qma1iwQAKUzbR6uio5zv0aTmXaYnaRm
wAAUeSpb4pIckU+zwbtIcmU0YV9nJQNlV8LpK+s2E0vl+HjVmFkUQoO2umX9HDeD
XFLSnk5pnu4Ew9IKt2yZ1sSnOFn7IJNfgkqWnrOeyKArb4EWpTii6Gz9Zu/Yzteu
07/X3rqpR2BTEU0nFx0spRtRMmZLYB8mBEEHy37hE5CXsop7w7QNptLqFHv0Xip9
lBgiO9NpDMQeCDEE11hXzUlpYkCPFB/3HDejxCiCfV1i74Yn2w/dLbiq+D2mOGgr
u9MB5HvrRZEGon806UMuUOSxWiF92b3uYV+btObyxBPGIuMoTRR+AWFYtm08cpRN
uAAYqm2/b53fyNrXLjJ+J5gZ38UTrpS+LCQ1qgs3qF/x9ivqY5I9blVq16SbPY02
NRiaXhCVFTkaZj79gjQ9Gv8YsWaWVu4YF59ZWZFwdggftzSq/SlE33QXwigWob6i
KfR+lenrNgVBn5PM8/0vnqLgusbYaJZn4wPSI/VHzpRvx/wVwtmmonIzpuVk9S3a
LUjq6AzKFC+KD3Lc954DX5l27A2YUxcUwpNEzYLoElGl72yIBI5/c8aoqPHJ4gZR
TpOvYxuZYAsYsQnhJB5AGRLaeao4dXDZoCay/Xa7iNRr1d4F1NRC65r1vLdpHcup
t1c2FT0cBOMeU2ILANdo
=589I
-----END PGP SIGNATURE-----

--=-LuIxMwf6E38sGSKyeFFt--

