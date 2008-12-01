Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50437 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbYLAXV1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 18:21:27 -0500
Subject: Re: [RFC v3 2/4] mac80211: implement dynamic power save
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Kalle Valo <kalle.valo@nokia.com>, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890812011110o4aeb8334k6702f64a1867e1f7@mail.gmail.com> (sfid-20081201_201015_818215_6A014B1B)
References: <1227901784-5325-1-git-send-email-kalle.valo@nokia.com>
	 <1227901784-5325-3-git-send-email-kalle.valo@nokia.com>
	 <43e72e890812011110o4aeb8334k6702f64a1867e1f7@mail.gmail.com>
	 (sfid-20081201_201015_818215_6A014B1B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Z+of9Gi2AcBnWktGved6"
Date: Mon, 01 Dec 2008 23:40:41 +0100
Message-Id: <1228171242.10627.48.camel@johannes.berg> (sfid-20081202_002132_605596_AF95ACA8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Z+of9Gi2AcBnWktGved6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-01 at 11:10 -0800, Luis R. Rodriguez wrote:

> Might be worth noting that when dynamic power save is enabled for
> mac80211 that this will only work right now for devices which handle
> power save in firmware as power save is not yet implemented in
> mac80211.

Power save mode inherently is a feature that needs to be implemented on
the chip due to timing requirements, what else are you looking for in
mac80211? mac80211 tells the chip "it's ok to enter PS mode now" via the
hw conf callback, that's pretty much all it can do.

johannes

--=-Z+of9Gi2AcBnWktGved6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJNGfmAAoJEKVg1VMiehFYvFkP/2ax/BcO+yIs//ohbBrhKs6T
eXs9fZEgu/0op6LNVO9IJDXU77AK+fgVroUhduxOsOvK8BRHVFboAtJWhekMbs4E
o9TZbVXCV7umoUS62hVtGck2+eqwgfwaJGTScLSyCTjYcBaJFvkGenZpxf1YXAOn
eenwc2ew22tmLvK9eoe96iYfAE6MCMWlcxi01eRifyvVcQzRm0gJVJPxBI9zQj/u
zSMc/FP2QRrDNZfxdI7C3Ic9eiAoaJsln3r6Dfxy2QZ3e18H3Wpv6ICoF0l9w48M
RPphjd+n2cuoaGxSnvXIFZ3M9a/TF5GdsTxYtcs4I5FemEXwg4yT302DZnsLHjcD
ZhAtCe/KnXGD7cggxg+/rTbO0pX7mXmAh/NuxVAbkcKTi971lsbZSMjksJzMt+fH
3/HmsEHQ3Aax05Ex4ASXEGAAihWf/vrxNqh08Y457Yp1K0JcE0OwEeRnSFGXzUlV
0sXsQwjKylaIySjZEf9uB6BhmCdUqxQiDrAGIHPWMs1rpYu/VrYDSPNwcNMnTyNm
9TnXPciymh8Ky6705l6aJrFDk8FmME/gkMk+3LXjrihDAo+qvfrNfH2cUfS0kH/z
TlzDes8EzDEAS+RTPjQedxnxnVrucjwCkegaydqlKrQjy6NMJWLZ10D5bjGMnwPe
dkNt0mXtdgAnBOvhzxCq
=oNTC
-----END PGP SIGNATURE-----

--=-Z+of9Gi2AcBnWktGved6--

