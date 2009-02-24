Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39747 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbZBXCRu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 21:17:50 -0500
Subject: Re: [PATCH v6 00/15] cfg80211: add a workqueue for regulatory
	processing
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1235192673-6314-1-git-send-email-lrodriguez@atheros.com>
References: <1235192673-6314-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-351cT5d//rDGZlQwjczo"
Date: Mon, 23 Feb 2009 17:56:57 -0800
Message-Id: <1235440617.4455.47.camel@johannes.local> (sfid-20090224_031753_399772_ED239592)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-351cT5d//rDGZlQwjczo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-02-21 at 00:04 -0500, Luis R. Rodriguez wrote:
> I found one bug in my v5 series on the workqueue patch -- I was
> accessing wiphy->custom_regulatory without first checking if the
> wiphy existed, in case there are any conflicts I am rebasing the
> other patches and just sending a new version 6 series.

Did anything else significantly change? I gave it a quick look and it
seems fine.

johannes

--=-351cT5d//rDGZlQwjczo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJo1PnAAoJEKVg1VMiehFYbTwP/imt77Hi6mtlwbIev3BVq50B
5DqPkFKsTxl+r1OFPMrh0e8u+4ZBhHN92AP7jDlqODi3lzyPodOJ/q+gUDlGvyFZ
kFTcF5s1BiT0+3NM9a8GJfpn3sI15O2TjsSr42wgVU8LgXV3FUeD5FPKkCKn5sGZ
x6mRnhLgvKPV1AwPQ5JQrOdZazsETx7fNgewx0uc7xMAScDcc1OyTOHlojsN2o8G
D06O4yLpIHuuDQD22uKEN3ppmIARfHyJ06X2shJbC96HjDHeObL3bK4IJpWScXHK
OfkKRcKqC35ZjC2zn+L3KCgLMTzYAW4ENs36BNTTnNEMMCdMxsDeWTnc71c532mJ
nUp9D2C4yNfSO2kC6mnAqnge4h5BiE8xBIMfyWvNXwqCfGoizPD9KjoJpvmdaepW
T5cB4UkC2ZL2sJKv4pwXdsTSxCxLMUJgRzMWvsH00qVos10gcyHuPE4i1xvrhPgN
sxqpHlbd5erbFbKca5o/peZ4lK9rPZWFa+3Vj5TFx2p4F0ijy3f0mbT2bZCHclci
XNUvETc8WB7pSn5ZR1J63lQxrPYCT0W/ZNkC0rewzs8D3LO7xQLR1DaFIqmRHLp9
8GknVoWKiERB4bgQsk92+EST6QoQQjRRvTUddVtCxT2n6437+0nZwGDw7WTnNTpH
7jo/N5zhsJ3PMt/zbz21
=q8yO
-----END PGP SIGNATURE-----

--=-351cT5d//rDGZlQwjczo--

