Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53107 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab0AMOxZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2010 09:53:25 -0500
Subject: Re: [PATCH] cfg80211/mac80211: Add TX/RX commands for Action frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100113113000.GA20835@jm.kir.nu>
References: <20100113101126.GA12548@jm.kir.nu>
	 <1263377951.5093.326.camel@johannes.local>
	 <20100113113000.GA20835@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7EGK4fl7jcBLCofL77wx"
Date: Wed, 13 Jan 2010 15:53:12 +0100
Message-ID: <1263394392.5515.272.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7EGK4fl7jcBLCofL77wx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-01-13 at 13:30 +0200, Jouni Malinen wrote:

> Assuming the later change in mac80211 is to start rejecting Action
> frames for which there is no known internal handler or register user
> space handler, the applications using this without the new
> registration mechanism would indeed need to be updated.

But we definitely want that, and it's trivial, so why not actually start
rejecting unknown frames?

<snip extensibility discussion>

So which ones do we need now? Could we start with code to reject unkonwn
ones, registering what we currently need (since there's a reason you
wrote this patch), and then extend as it becomes necessary, for instance
for vendor frames etc?

johannes

--=-7EGK4fl7jcBLCofL77wx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLTd5UAAoJEODzc/N7+QmaZE8P/1YTJTtZwX4Q+6i8BSGe3tW+
Won+y0aQQRd8tB2f0c7TYe8ijJXs3xCE8T+IJa11spkFFLUC1C9EXa5/iY5iniGV
T3la8FlWtTTStZAu7X2/DkWMdUKoKUfXXyKmIi4mY5BS/0UPg6ZUCI0reVzFc/N5
D49Pf7Hj4S4Am4yaf1RN2VI8W6IZH42NyWZNrIKjfI0PTEtSvBD5mcrq+Vq2gIPT
Mqvb9kZBsOXtlfp16sJpoH1idxb4CWvLVTzOd2jg/w0nGmv2oKT2M9eOVSpdsnKt
B8GFi6Qsi4CjrX5vkGUCf80i6QlxKTNFfTpHKBGGvIcZ2P7V7MN2OqmT9TJvfSPH
g9AyJ19MAEZ2DD/FA115eaQfrRk26B7NKSTGGAz1zsSZQhKOFE/zFv1Y589eIj1V
DppsfGWnTeSMkTI0MjQaXN6PPjdj8lUM8iv9nzt10jVCza+dik+SIhtI7iettEuJ
P5j6gHyyNyU2d+qLb6HFOksY3ufVvrxFmg30FbbClDuTjt/Qs9NSuwG4FeY2u+Yi
r1czXIJN/gP472E4pFFn+USXjnkhEd7Kp3XiQI78D/+UAjGjrhMVy7twkbImvwnv
ZbPjvS4NTIvzqtlHzQ3eMx/7n77kZuSMTH8qxkrfE8cAEOpNAVbnjTpk7cb0q460
3WSEP9Ca/bFoogBrubE+
=nb48
-----END PGP SIGNATURE-----

--=-7EGK4fl7jcBLCofL77wx--

