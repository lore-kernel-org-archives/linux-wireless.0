Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47386 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbXLJMe6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 07:34:58 -0500
Subject: Re: [PATCH] introduce WEXT scan capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Dave <kilroyd@googlemail.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1197289394.6035.63.camel@johannes.berg> (sfid-20071210_122324_683415_A737E009)
References: <1197073366.4563.15.camel@localhost.localdomain>
	 <20071207.181221.09900510.davem@davemloft.net>
	 <1197221467.9149.31.camel@localhost.localdomain>
	 <475C3538.1070501@gmail.com>
	 <1197225300.9149.74.camel@localhost.localdomain>
	 (sfid-20071210_002335_513389_B559D9A5)  <1197289394.6035.63.camel@johannes.berg>
	 (sfid-20071210_122324_683415_A737E009)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aa91SjzQY6O8v9AEEmXn"
Date: Mon, 10 Dec 2007 13:34:52 +0100
Message-Id: <1197290092.6035.67.camel@johannes.berg> (sfid-20071210_123501_563718_E6816913)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aa91SjzQY6O8v9AEEmXn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2007-12-10 at 13:23 +0100, Johannes Berg wrote:
> [what happened here with all the gmane addresses??]
>=20
> > > Since iw_range is not packed, there are a few locations where there
> > is some padding. You could quite easily shoehorn an 8 bit bitmask into
> > the existing structure without impacting backward compatibility
> > (unless userspace is using the padding for something). For example:
>=20
> Ouch. But possible since we cannot do this.

Eh. I mean. Possible since we cannot expand the structure.

johannes

--=-aa91SjzQY6O8v9AEEmXn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR10yaqVg1VMiehFYAQLgrRAAkkugN9LsawQWJmEwFr3v9rLBMMsY42xx
SxdItzbilCbXFCfPopi0q2VESaMvgqQJZWGaS7EDpFFS7thpMb+OD64raP52r2U0
rl7vJUqC88fmKpalEtxFMWMEagXIlNjWNxUeUp9aBcBeDEN/UqGbTj7XXr20x1dM
vlnQMon3tqRjZql0zWCmtmGT/QqcZbfoYfpW9Aq8MXHd+RHGlJh+KiA5Wd0eldf8
Ojpi3XLLMZ0gD22nbUIeWPKME7OHFFDSnswFxfSdQXdIp31VFSD//ZTqiNLO/K1T
MQfeIFR0KiGLFRL6uvFBGHtpDAsltBHJwTxGs7ldfuMXChofHBqTBp+kbdkFGDYN
gYO3+5aDWolIS3jfJ/HJQgDSkuDgj2k9qr24gB7QtNYwzCdMsU5d2cxbkophrOU5
AbvZmjkkZ7n0Ftrj79UO/joHUQx6aPLgUCKBAw4I5wifUirnkTgO1T+nBWsyOAWw
Z+Yio8xFnocI80T3WX5Oy6KClwjZdxwyqiw81LBTpw4CsqY+Y9k+gocSX/0tDler
Y+MLYzHIv9bZmaDlf0TIKH1OtJ5SytHkKqknnDEnOXGwWP7J8xfs3pKGuTACgFeU
du44JH0mDdmgQc3uEYMzJvIAaOzCMkh5XKEUumjQ/XNYldoJ3fW0aUzoxNBH8xbz
aegOgA0XHi0=
=EITJ
-----END PGP SIGNATURE-----

--=-aa91SjzQY6O8v9AEEmXn--

