Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40468 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbZJaFqE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 01:46:04 -0400
Subject: Re: Re[2]: ieee80211_tx_status: headroom too small
From: Johannes Berg <johannes@sipsolutions.net>
To: Nikolai ZHUBR <zhubr@mail.ru>
Cc: linux-wireless@vger.kernel.org, Ivo Van Doorn <ivdoorn@gmail.com>
In-Reply-To: <7111590175.20091031005644@mail.ru>
References: <1094614475.20091030230028@mail.ru>
	 <1256936341.3555.67.camel@johannes.local>
	 <7111590175.20091031005644@mail.ru>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-f2BhY3CAP9O4p5WZJwBC"
Date: Sat, 31 Oct 2009 06:46:07 +0100
Message-ID: <1256967967.3555.71.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-f2BhY3CAP9O4p5WZJwBC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-10-31 at 00:56 +0300, Nikolai ZHUBR wrote:
> Friday, October 30, 2009, 11:59:01 PM, Johannes Berg wrote:
> >>
> >> ieee80211_tx_status: headroom too small
>=20
> > What driver are you using?
>=20
> Ah, sorry, forgot to mention. It is rt61pci (RaLink mini-PCI card)

Ok. I looked at the problem and it's a very odd problem -- mac80211
should always reserve enough headroom in buffers it passes to the
driver. Does rt61pci somehow realloc frames?

johannes

--=-f2BhY3CAP9O4p5WZJwBC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK688XAAoJEODzc/N7+Qma+IMP/0+fSKSWENA5dcs6EU2pv4Wb
aAy9F088ZFZ5zEo2aXPBPdoNiL1oTYLbleagKVyKg20Rx0e6notDK3vWMZbXb2Dx
Owx20ZNx5dlh9/+6QXKRoN1MhQWuQaHt/XzSCUde0SKZs0BgXCEFqGqInK1WXD/V
G+/MEZkewdkoEhumyah1af1rCLiLVcbVi23KsxfBeSc6TM4EQ20DybaqqdhiyPys
Wht55H5dEJo66Fqytw8SnhMShP7+44yKBd72NHWQQ9AubUGdAQrlmAK9Vujrvtrm
QIuwT/zZrUCBtJIHWNKoJGH7DVQMcXNSbH2QpShdi4yY+vL8Xhm77QVNZ/8b1s3o
2WHvyoO6EOhmvLI5ddCx6+q43WReH8xPn/j/rw+9QC3Mpp5JHkjiSItHWGktl6m/
DKAShHIrXrr1z3E5w7eGHp9kIHRaDsZEB4zoirL2r6KLYD0FhRsWgwY7UijeLgo2
1BPEcDrPCvOGLIfxxqDoJK9FBl2kS7d5KANn/L6gKINDw391et4IVBQVaGipsop0
Wshruhs3ZeYUCiyD6uRQfgfoChJVC3SMjqzHpE8is1zjGxhsmSwRKcHubzNyHNsg
858gKIa1upzaE+N1yzG45uDLf6XpkhgLQyLyVmV1XUJPNjg/qDhtbgfxQQyY416o
GBk3mLejwgKNxR9EJPXs
=aKyI
-----END PGP SIGNATURE-----

--=-f2BhY3CAP9O4p5WZJwBC--

