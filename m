Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40233 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZLIIYy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 03:24:54 -0500
Subject: Re: regression: rt2561 frequent "Arrived at non-free entry" errors
 in   2.6.32
From: Johannes Berg <johannes@sipsolutions.net>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	Andi Kleen <andi@firstfloor.org>,
	linux-wireless@vger.kernel.org, Tim Blechmann <tim@klingt.org>,
	rjw@sisk.pl, IvDoorn@gmail.com, linville@tuxdriver.com
In-Reply-To: <4B1F4A88.5000803@gmail.com>
References: <20091204233202.GA13658@basil.fritz.box>
	 <200912082339.16893.s.L-H@gmx.de> <1260312016.32227.6.camel@johannes.local>
	 <200912090053.25798.s.L-H@gmx.de>  <4B1F4A88.5000803@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MeW3At4olF/OzfOZ3TCH"
Date: Wed, 09 Dec 2009 09:24:19 +0100
Message-ID: <1260347060.28424.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MeW3At4olF/OzfOZ3TCH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-12-09 at 07:58 +0100, Gertjan van Wingerde wrote:

> > - pinging rt61pci results in rather unsteady response times (packet los=
s=20
> >   can happen, but rarely), which might be a side effect of the card try=
ing=20
> >   to sleep.
> > 	# ping rt61
> > 	PING rt61 (192.168.0.71): 56 data bytes
> > 	64 bytes from 192.168.0.71: seq=3D0 ttl=3D64 time=3D1016.131 ms
> > 	64 bytes from 192.168.0.71: seq=3D1 ttl=3D64 time=3D17.574 ms
> > 	64 bytes from 192.168.0.71: seq=3D2 ttl=3D64 time=3D906.219 ms
> > 	64 bytes from 192.168.0.71: seq=3D3 ttl=3D64 time=3D1.499 ms

> My guess is that this is due to powersaving being enabled, where mac80211=
 and
> the device go in powersaving mode and then it takes a while before packet=
s
> reach the device. I don't think this signifies a bug of some kind.
>=20
> Johannes, is this correct expected behavior of powersaving?

Well, it shouldn't be quite that high, unless your beacon interval is
1000 TU.

johannes

--=-MeW3At4olF/OzfOZ3TCH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLH16vAAoJEODzc/N7+QmaInMP/RGLgK25VOfJ7SF44hqOzijk
MLsGKvdfH6F6MOW/uwhOJA9TyHln/zIka81fSsvVH3HO22LEc2sUYNsUj9r5Cqsf
htHbqQQ9yCj1L0LmzzKrImmrqb+Zc4s44c3rSg0jj6etXXw7ltiZmMPj7WF4gWoT
hT6b8/Jl0dkDss3k4w6GJx5AaWHsWBYZfWMLm32I3D+L0z+9Q75E9WAY0thFhk3D
QonmCH0XTYRL6VqwIo1DXBrPhos1BsR7XYIQBDJWk1+5KExW9KMw+DxZkTwkayYM
0gv9aaKb87wMudOLpODd7cWy6UMow3yXgfkq/nW9Q8MIdG0+WpZtA5US+RrGqnqY
Myc6KmMYegn2C77uJ9FfeSYB7+8kVEEzQQylMai80pFX0wtTCTxQ5Bbhy+xoN1Ea
0x06+zGsjqlRZaEujylei9uAEBEzZol2WRqiodRIQLhAOfWHbIB5voxVgO7Ni1iV
NH4pSl+BJGCpjv0yv0utYGTX3Gcy1VkPttQjX0oEICwnbxUjzCpd4ERDlVi5d5qh
Sr7IQMgZCI01CSGIIHSuZSVLJRYToHOhwhXaukSXRmPYU827j78XHBZoKoaz4kh3
zTMZZ/ijYknoFZuWg/A2xHmfRvZQP3hGMqeYlFN52xt8CP4bLVCnVFCTXNDo7ERe
tGPiCMThU2+yGRooxIvy
=kqQg
-----END PGP SIGNATURE-----

--=-MeW3At4olF/OzfOZ3TCH--

