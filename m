Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36741 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbZBXC3u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 21:29:50 -0500
Subject: Re: [PATCH 0/4] cfg80211: few minor enhancements based on reg
	requests
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1235193856-3524-1-git-send-email-lrodriguez@atheros.com>
References: <1235193856-3524-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qmLN4lAVJhqAOGUaq6YP"
Date: Mon, 23 Feb 2009 18:00:23 -0800
Message-Id: <1235440823.4455.53.camel@johannes.local> (sfid-20090224_032952_457547_ED53FBBA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qmLN4lAVJhqAOGUaq6YP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-02-21 at 00:24 -0500, Luis R. Rodriguez wrote:
> These are a few cleanups based on the new strategy to use regutory reques=
ts
> structures from the workqueue. We still pass the wiphy directly to
> __regulatory_hint() and ignore_request() as its used often.

Looks good, and the "[PATCH v2 0/5] cfg80211: enhance world roaming"
looks good too (well I had two comments or so)

johannes

--=-qmLN4lAVJhqAOGUaq6YP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJo1S1AAoJEKVg1VMiehFYYAEQAMEEsntc+PPAvLDJPF23n2Ju
l9MoxTWIQsM4uqKju5kJC113H8vPGkXiS/E4Qcex6gZ/jxSqiZ/SOEuKRHqyppsr
zPnCY0cujjV6WrWsNA0KacU7lv6E9JYRfD7afNSevbhS/RH4BFnikqPddMgK6nqv
osYcLI2VHuqKwKy/IG4DUDE82A4tZVV3LarpNPPUnvyP8ibTKkjWlBD2mmlYr1WA
AZ5DGffIHwMTpS/HHDm+38Nb2Audbgpg7bmOjm0fu/ajGemrPe4lN8NwDBaLvTEf
oDFqewQ2WlWTQ9p5YVoxkho9LhIVdtlc455ztYiW4uQZw3PSPfN0OwOefIo2Scdd
fHgIWd+Fgs6bgSXFEIp538aYOLO47q45duTASoyfQ03eQ03lP0j9KlFUpw2/IAhB
fdfe1Y5P7GYWuxEx5rlTYrystTa+CsEI3dWtnILJr07e1CPGqHxilMulC7rcX7kC
OTNoRZWURJrdzAdrO8F2XSFGKqB8TBGY/zUVBxbqkmM6IHYvNaIKs+RP10PphBeT
My/WGXDzlOznMoGRJzZoHGECzQVboPZCLpLpZ40JGlOzoVh1b1uYiWKziTQpBKac
PRCX1Co+5o2J2wf61wDOSKw7R0P348psgFy+BTJLAW6w0EeTYsm8Vi3GUJ4tpz/H
ZpfsnqdpXNxku7R8paiN
=z7yL
-----END PGP SIGNATURE-----

--=-qmLN4lAVJhqAOGUaq6YP--

