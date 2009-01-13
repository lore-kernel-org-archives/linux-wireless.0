Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39713 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbZAMXDP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 18:03:15 -0500
Subject: Re: [PATCH 12/12] cfg80211: Remove CONFIG_WIRELESS_OLD_REGULATORY
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890901131500j32357b92kf57c0b12d38c9ad5@mail.gmail.com> (sfid-20090114_000033_332254_1EEE9678)
References: <1231876675-20518-1-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-6-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-7-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-8-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-9-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-10-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-11-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-12-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-13-git-send-email-lrodriguez@atheros.com>
	 <1231887058.3728.6.camel@johannes>
	 <43e72e890901131500j32357b92kf57c0b12d38c9ad5@mail.gmail.com>
	 (sfid-20090114_000033_332254_1EEE9678)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HOlOI2n3glGo/Hz3eISu"
Date: Wed, 14 Jan 2009 00:02:45 +0100
Message-Id: <1231887765.3728.14.camel@johannes> (sfid-20090114_000318_970181_DAD9CBF4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HOlOI2n3glGo/Hz3eISu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-13 at 15:00 -0800, Luis R. Rodriguez wrote:

> > Don't like this much, it's not really biting us (yet) to have this code
> > around still.
>=20
> It means double testing, I was going to test all the work in this
> series with this option but I figured it'd be better to move on.

I don't think it matters much since the impact of this code is now
fairly small, we simply start with a different initial setup which can
always happen with crda too.

johannes

--=-HOlOI2n3glGo/Hz3eISu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJbR2SAAoJEKVg1VMiehFYFOMQALb5rPHBsmxwDWfjxcm8qFCg
0aYC0qJ1wT6dTkkb61wxkKGXI6qZ9EaYbv1x8bCwS/Z5BFjZId1k6ZSWZchaOb4v
kLPOLX1YK0hr8JTyKFsefKkvVyj+Rj43Wvlt0JRgpiP2DumNro3iAuKATJdvfAI5
6+opPE0EsGjCYnVuh+j46vk6suDzWFXi0fCx00aMpm6Br/b8MMY0lQ+pzm0NzXIZ
zoYSjcy8TIlPvyd0SbOtXshWKmQaChhzQu9+zBSwclNmM6ufE1UpItia8qPP6XY8
DmF70zjZJav9AbpUiQCXRP/2748U+xJzN7ZOTI3gXXDR+K8BoqIWruY2VbfM2Fw5
E1KBuMAn4xKShosdjvU2hC1gzFMzg4m+sCBbeCjT2MS0r5IMYBctJb7V9O6cIydf
qUfazpxo2TZf3EsN7ZV2hj1RA+99rzcnX0SnvEDsreIz2pcGyU13iVeNVGMiYwBZ
ZXnnMe37oOZOkm/H8RIlBbjpcURfCugZjuIquMce33D3H6paNFdsV6VTJafpJLpk
wCqKrtf6/zTxWqT2AUsoR9TuZNkXiPhh9F/W6J7GOBqvyM4V7RGgfMRepIv/pO9H
8HaDSpaY1bO76Xs0AmlDgdf1A98sDH3lZmOt2/34AI0P+Oojk5+266uikRoaD1Aa
AanjOqad3WC9B7i6V3gN
=pp74
-----END PGP SIGNATURE-----

--=-HOlOI2n3glGo/Hz3eISu--

