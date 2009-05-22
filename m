Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48044 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbZEVPcH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 11:32:07 -0400
Subject: Re: libertas firmware naming confusing
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1243005119.2461.15.camel@localhost.localdomain>
References: <1242979352.4212.27.camel@johannes.local>
	 <1243005119.2461.15.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FOXk0BThhnJ2D4sBRlBz"
Date: Fri, 22 May 2009 17:31:57 +0200
Message-Id: <1243006317.4606.27.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FOXk0BThhnJ2D4sBRlBz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-05-22 at 11:11 -0400, Dan Williams wrote:

> >  2) in the USB case change the driver to load libertas/usb8688.bin
> >     instead of just usb8688.bin and move one of the versions to that
> >     filename in the linux-firmware tree.
>=20
> Yes, this should be done.  I was unsure what the policy of breaking
> firmware filenames is, however.

You can always try to load the new name, and fall back to the old name.

> > The current situation is very stupid -- users can find the firmware in =
a
> > proper repository but it doesn't work out of the box!
>=20
> Nope, though these cards aren't usually found by "normal" users anyway.

True.

> However, I'd like to preserve the the distribution of different firmware
> versions in linux-firmware, so maybe we should simply point the drivers
> at specific versions and use module parameters to change the firmware
> version?
>=20
> modprobe libertas_sdio fwver=3D8
>=20
> would select libertas/86xx_v8_helper.bin for example, but by default we
> use v9 or something like that.  Would that be acceptable?

Sure. Might make sense to document why you would ever want to use that
though.

johannes

--=-FOXk0BThhnJ2D4sBRlBz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKFsVpAAoJEODzc/N7+QmaNPAP/1/NnRrPQA59Y6ezMqgRNb1p
jG7dMb2UBYx3YjZNDcj/oTg2XS6zyj4tZl9iR1E6EVi5+cS4LMYXZofGLMNJnzgb
orKCnFPBRKJmzKPH0tFtmbHcGGIby1n1VwdkHlKPsuiQfbmtC+6+bRTQzeQNT8ix
UVvhWWJ2WcCyQxN8ofUaY2XjdMpwwvTKSDJJKvsHS2Ksktgi8TaL8IyLgYTIkcDe
QBknC9yGjmzpny23RYgb05ztzxzWZbElXcmqSBqEfx1/mEbx2gKqTOOWUvJJSh0V
Vd4nTTLe2oUl6tchgAki9wr1GL2TmGSm+ON2PvKTAVINCuwOtVZb7/NJDHXOo2H2
P8tYFo+0mzON0D3IrT8qWn0luj2mCTutFmYGyhOVZUvAkIBYlysX0+Fflh2rL+GL
BlpSrd56qlpXV9Al/Q9JYxwBZ3iCCulhiBmMnqMF1IOy9enqnuqPTuINF5btiUof
7XrpHOBfFK/izhty/bFZ/rEJ7rvUQ4jIs2vRa6Gjq9eFzT2cJ6Xh08Mcxjs/7Vp9
ySaMkLVPFVx94qQLrKW3n2Is16IwdpdcJ9GX3XqAw7VOU1Dc+7b6Bu/KtI85c0qH
dAchSWUTUOr+ARmLl9AK0ERmJyMHvVxl6bAGWknOYjDxEGgZNIGegzCp4WBf5iqC
LQzFIknYylEZybnyd6iX
=xdoe
-----END PGP SIGNATURE-----

--=-FOXk0BThhnJ2D4sBRlBz--

