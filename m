Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49694 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbYGAJ7M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 05:59:12 -0400
Subject: Re: [PATCH/RFC] b43: remove input device usage for rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Adel Gadllah <adel.gadllah@gmail.com>
Cc: linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	stefano.brivio@polimi.it, Larry Finger <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <6cf6b73e0807010255x1f2d8a21m8ed3e712012ea757@mail.gmail.com> (sfid-20080701_115519_696541_D5864902)
References: <6cf6b73e0807010255x1f2d8a21m8ed3e712012ea757@mail.gmail.com>
	 (sfid-20080701_115519_696541_D5864902)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dbvzEn28OO+liWRJMUkL"
Date: Tue, 01 Jul 2008 11:58:24 +0200
Message-Id: <1214906304.7763.34.camel@johannes.berg> (sfid-20080701_115915_919075_D634F174)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dbvzEn28OO+liWRJMUkL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	rfk->poll_timer->expires =3D jiffies + B43_RFKILL_POLL_DELAY;

round_jiffies.

johannes

--=-dbvzEn28OO+liWRJMUkL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIaf+8AAoJEKVg1VMiehFY9HYQAITgC65PszCPErl7lSMn/GT/
ckxV8lug0iVkgTwyU+stHKdp8uuue+/TonFcTtQY4kxCbGF/KzlwLN8lMjgrsypZ
nI0CclZ63XpY4gxG9ug35kwjl4rYvS/thAfEAOIXbja8Qg9aXJ74DVHXu5d855vB
kbGeEPt5+GdfWORI3Ac1w//nOeakCjhERXoapGenOmEPk85hXeYfKy5MbMeiGYag
ZfIGeBf1hAvLUp/0xNqfCX1aT7myITwPcAcqV1nR4XbwXFl09vL8c60xI2oB+d0e
XnTGUOn3/KrJNpyDx+dB7OaVHYVb/cXRaeBM4YS+/cI3rYmKqPH/1oQxH7uWx+gq
OKKOIwa4T03eASEzqT2vFTTgUBo7sP3i7svtN3eF8+nRgujY5JYfxs2VInYHtudH
wsUiWgAdseyKP9bLAL1tUZ1kcqXYDVR/ZUC3XrGXFrU/EWfOmWEmq3F/hvsv6QJ0
XG/wl1TAad6vVSywpkr02lUuC3CGcWtebnX80kcCDpR6o97lFA4SHZHUrCFvtvCb
67CTTrHtPqy0Tp4CGSupmAeP07LONZnjE2tlgpAvLEiIY4khqZ74hMfJhVE25k6g
GDCeafUSkwrlFIbexIuE/r/gSfEHOVouR1FGiHQ1e8Nc6jdkGRPaYuNGc1tbLn53
C5BXVtpC/f/2LIVv7rgu
=SpmM
-----END PGP SIGNATURE-----

--=-dbvzEn28OO+liWRJMUkL--

