Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40708 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbYJ1H4o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 03:56:44 -0400
Subject: Re: rtl2860 driver in mainline?
From: Johannes Berg <johannes@sipsolutions.net>
To: Thorsten Leemhuis <fedora@leemhuis.info>
Cc: Greg KH <greg@kroah.com>, rt2400-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org
In-Reply-To: <4906B944.4010105@leemhuis.info> (sfid-20081028_083550_035307_58424396)
References: <20081028004915.GA3442@kroah.com>
	 <4906B944.4010105@leemhuis.info> (sfid-20081028_083550_035307_58424396)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xeyeRlh72Xua+lWHEIVJ"
Date: Tue, 28 Oct 2008 08:56:38 +0100
Message-Id: <1225180598.3796.66.camel@johannes.berg> (sfid-20081028_085701_572381_F38478C9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xeyeRlh72Xua+lWHEIVJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-28 at 08:03 +0100, Thorsten Leemhuis wrote:
> On 28.10.2008 01:49, Greg KH wrote:
> > So, on my quest to suck up every out-of-tree driver and get it into the
> > main kernel tree (drivers/staging/ to start with), I've been pointed at
> > the rtl2860 driver.
>=20
> Does it really make sense to include a driver when a different one for=20
> mainline inclusion is being actively developed? It might give some=20
> developers the impression that it's worth spending time improving the=20
> rtl2860/2870 drivers -- which might be wasted time in the end.

I don't think it makes sense either, at _best_ it'll do nothing but help
a few users [1], and if somebody actually starts working on the vendor
driver because it's in staging that's actively harmful to the real
driver by diverting resources away from it.

johannes

[1] I used to think the point wasn't to make users happy but to make it
easier to work on those drivers, but that objective seems long gone

--=-xeyeRlh72Xua+lWHEIVJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJBsWyAAoJEKVg1VMiehFYqAsQAJ9PluubraVrnoaiwpJIMCSH
8ByKgfXixchtZ2p628IeBRyM65A3oOC2FzTLaM895H/K+txM0RWgqJINKSHQsQPZ
igw6/0H5AJG/VxpzSVdLrBKR7lpwpcc5OL9aGrNDu5F8xBVtTTP6byBHuALXPLzY
TcZ5egz2C1g1b3kUXKFbgRgW+gaQs/4RkeJDSF5kmZxXALZ08QgJvNyuexscW56+
dReq2jwX2EdkG4mozaVk7B/f0pDWKvYF2nS2h2mZUq3zvRYoKM7F9l/Mm8fygou8
KW4EQhFUpU5MILnIl2pNXILl8/iL/FcNGtpKgMLL3b3w0Ne4jrHmD0YUvBX58oZV
fef3+NG+H0KU3Zv1XhE7VJLuUh1G+9gaBzIiLXD8r0mv/wR4lgcqYZNp9otB3eYQ
EmChUCH0xmSiqQR5+uBxGin4n9EQCeiq2zOayUkNOSCfjtSdepkidgLJw/IBZWBv
1L9lg/z06ExeyakzEv/rygJIvM9nZ0C3qG4C7iWoTQ8Y3JwaNanpEBrAGVBi0GoG
s8y2CkZL91rfEIIqFEntnssr7Iu9Fcd7+/hNP97mMpK1KN1K7JFo6o3H28+sBe+s
fN1v9U+Ro4lbpheaG29lHHw0X/AAM/YrqMYUzhVOYuifWoX8XlOaDLPq6N+5ZsDc
WwX8r57OpCxKNl47d+eT
=h8oa
-----END PGP SIGNATURE-----

--=-xeyeRlh72Xua+lWHEIVJ--

