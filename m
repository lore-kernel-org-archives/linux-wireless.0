Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38428 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbYLJRUo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 12:20:44 -0500
Subject: Re: [PATCH] rfkill: strip pointless notifier chain
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200812101801.35735.IvDoorn@gmail.com> (sfid-20081210_180139_130277_7A89B7B4)
References: <1228927728.15837.10.camel@johannes.berg>
	 <200812101801.35735.IvDoorn@gmail.com>
	 (sfid-20081210_180139_130277_7A89B7B4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-evFmBbvvBXxNOBkdfla1"
Date: Wed, 10 Dec 2008 18:20:09 +0100
Message-Id: <1228929609.15837.36.camel@johannes.berg> (sfid-20081210_182046_981759_46ACF6C2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-evFmBbvvBXxNOBkdfla1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-10 at 18:01 +0100, Ivo van Doorn wrote:
> On Wednesday 10 December 2008, Johannes Berg wrote:
> > No users, so no reason to have it.
>=20
> Henrique, you introduced the notifier chain, are there any upcoming
> users for it or can it indeed be removed?

It can be added back with the users when needed.

johannes

--=-evFmBbvvBXxNOBkdfla1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJP/pFAAoJEKVg1VMiehFYHI0P/ivaS3tFHad3xNzqq7suMEN8
Sy8vXln2h4PDvEdDpye+yZ0VIE0GNdbi9SDpiWTyT0n99fUGVd+lT3YVsCNWXCaB
Ubx8XAsxYclv1EqnCcCBMPQa9DFycAcXABQ7XsvHaDN5uDvnuVvMlb7cvbIyAd1F
jSEpZLyDcMc3pe1M6lnxSn1NS7LZuiIwkasqQI2hrK32/vqYTX6hpUCO9hhGOfS/
zmDD9zGPFFLnIou/Ler+kAaPk0We2eI7A7M3fgf+EW5MtTkA2Uk91zvg42W06NZG
sB0031wGb5kSrXzHASisJs2Lzw3DBCspdsa2j87EHelKFPFvT64FvioyaochQ4EW
Krk76xHT8XY9qp8cu/kbrshZYwBK9XkG8n4SjuwDReZ2PVq6oVEuY+DUbY3K4rC7
R/YR89ElbGsGB4nzLWs1PE+3nJIQ7oarikrsQEteVS162z8C6kTgwnVGJAeAs0h9
ft+QKekbhq+Wo8Xogd000gwNCVrmmGrqjlaM92/Z7MXT0fW5wDWsPRw9SXeXAMLS
VQPHErb7cz4u4St7oX0PnXmN7H5F3t8up1RHvsNVUf9B7YsTw24+0qAVE+bSQ+dd
mf7Ogo9gZBxdUk65avE4/JZx6f1T8Tcx71/r7GU6SsuMHUbM99TaCAzDACaiuiLM
0egFyX5KYTfaoCHT9a6a
=wUg3
-----END PGP SIGNATURE-----

--=-evFmBbvvBXxNOBkdfla1--

