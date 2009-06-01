Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45865 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZFAPxa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 11:53:30 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090601155020.GC15485@khazad-dum.debian.net>
References: <1243841639.5299.8.camel@johannes.local>
	 <4A238EA2.4040106@tuffmail.co.uk>
	 <20090601122839.GB11011@khazad-dum.debian.net>
	 <1243859931.5299.17.camel@johannes.local>
	 <20090601124553.GE11011@khazad-dum.debian.net>
	 <1243860606.5299.21.camel@johannes.local>
	 <20090601133351.GI11011@khazad-dum.debian.net>
	 <1243866545.5299.25.camel@johannes.local>
	 <20090601153620.GB15485@khazad-dum.debian.net>
	 <1243870669.5299.29.camel@johannes.local>
	 <20090601155020.GC15485@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Lh8mnSBon0Si2dXY56t2"
Date: Mon, 01 Jun 2009 17:53:25 +0200
Message-Id: <1243871606.5299.30.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Lh8mnSBon0Si2dXY56t2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-01 at 12:50 -0300, Henrique de Moraes Holschuh wrote:

> Yes, it "calls itself" right now... so I can certainly do that :)
>=20
> However, the in-driver shortcut means I give rfkill a kick and say "the s=
oft
> state has changed, deal with it", instead of "please change the state" wh=
ich
> it might deny due to EPO, etc.

But ... now I'm confused ... why would the driver ever ask to change the
state? Sounds like something that should be a button instead.

johannes

--=-Lh8mnSBon0Si2dXY56t2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKI/ltAAoJEODzc/N7+QmaqZ8P/1sTc35eZfNyYkMZ9BrOfB3j
gUB7jLiZbE0Sgs3Xez/JLXA091VrRpVXMkzCTkV/jvwlONv8HYFGNZV8O033oTLT
Flzc6CT3BuwAKIoJLRKMy8vD/okxaKBEwcqNaAYj1FDhg6OKYntx0DhyjOb9tGks
YeoLr3aRea5lFl8UjrDs6on5tG24PQjSPvU2npiukd13CqJGACw6pkyCR0a2wOyP
L5FMVmlvfY27Jymrq+TPZUAQKvVIxtqgYCYLrZsxDHgyhw2yzlgKORUtbBgn0sOp
r2mgnBqWf/jNxCNOw59zD10NmQUAyoAQXrzEPbYAI0arXwmaH/XJxXExcbli7VEr
kx2PO+lFX7QF8cpqbgpDuqr7bgX74fIM1ObfkRJXlFPpStxGWzlPVI27Veb9nBuv
wmNR7qahkCtAH8gOG9Ye8uT4bQz9FVXKdLpcKek6GREF9mO3VsE9x0W7DLrnMObb
7hc0K0X/Rp552JpPe5OzRpTBqIwfX5PVZMhPnQn+7dfsU47Jhbl2JCwlu3p7ogBM
+jmbNAEBWuCV/y50N0KtmqCjIljsljEk7urK1qy6PNX19hD8dxUEYITmFSTha9mj
RA4yoUkZVb1bOOVW3gPMEFzBnrQSu+m93N35vfZR8PMeutr7xs2LWBbVwUWjQ9n8
MLIWgqnSaF7LgqaA2ONZ
=yXok
-----END PGP SIGNATURE-----

--=-Lh8mnSBon0Si2dXY56t2--

