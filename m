Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50080 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbYKSL4t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 06:56:49 -0500
Subject: Re: Fwd: p54: testing AP mode: cannot switch to master mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefan Steuerwald <salsasepp@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <f76a32050811190316o28a49cddte30214c217877078@mail.gmail.com> (sfid-20081119_121706_513504_3F0FBBDB)
References: <f76a32050811190306s6a86f46dwc245200069ff8a82@mail.gmail.com>
	 <f76a32050811190316o28a49cddte30214c217877078@mail.gmail.com>
	 (sfid-20081119_121706_513504_3F0FBBDB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-y7gI+vpxTstX5MFQNLhg"
Date: Wed, 19 Nov 2008 12:56:13 +0100
Message-Id: <1227095773.26243.22.camel@johannes.berg> (sfid-20081119_125653_997847_8E964B2D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-y7gI+vpxTstX5MFQNLhg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-19 at 12:16 +0100, Stefan Steuerwald wrote:
> I'd like to test the recent p54 AP mode patches against my XG-603
> (ISL3886) MiniPCI card.
> Tried that with the current wireless-testing.git, compiled ok, module
> loads with 2.13.1.0.arm firmware.
> I was under the impression that this should now work:
>     iwconfig wlan1 mode Master
> however it errors with:
>     Error for wireless request "Set Mode" (8B06) : SET failed on
> device wlan1 ; Invalid argument.
>=20
> Being new to wireless, I'd please like a pointer on what to
> investigate and which info to provide.

http://wireless.kernel.org/en/users/Documentation/modes#AccessPoint.28AP.29=
infrastructuremode

johannes

--=-y7gI+vpxTstX5MFQNLhg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJI/7ZAAoJEKVg1VMiehFYnKYP/21oOHS1a6LayFJOErhUYRMN
0OZ2910dIZ56ww1MYb2m1t4Ku4Sij/8nE8k04xKJxWugLUNnMtW9WoZtzA2mPWKW
tYpumklrNTNx0YM4bAqbdLTrIf8cbbXQ6FRlYU/hTfDRRAaoWWqb8llmStzFx1cT
C1QaE1MYXJ14roR7ozFOSPSkE1K1XRdZV8rtcbu48wh/FTT6H4w6rOyCAGFx4C+W
flp+9D/OJrWVmaCXcPdXBlzeSXfbqzP1DKIP41/iWcmf70RhfGuj7iR5ZwRPuxGm
iC7+eA5f2y1qLfy8SjuvGrstSiwgtkk0sq9mXs04TgJd8MshCw1Dzp2/a7VEY5Uz
kEQI4BxKcxbDSJiQxOz0qBliNptaxCdeXm6erR5dnENG2P9pTEvUMjH823jTO1a3
3u3C/dqrqsaxhw13oeN97zkRats9RkVOQ6e2xA+aLZhpfndCvc4E7m0wxmhFvIGJ
GbeRm4u3B7o15EuagMxWMdMzst9gi/zR1N6jDwuZmsFa7rKnRel+oV0D5GoFOiRI
+LUE8MGmN/+il4VGCAQMq+V/8kvcRqxQS1DQC9ivCy9bcUd5qV0v77B0ZkLbm2IY
c3U2y+u/pJ9gOpefCkHwx5FNGqHkTqFMSOetzy175WVYTCslNqADO/T9pFCwTi4q
duSiVDp8Ce49ANztV5Ad
=3T6w
-----END PGP SIGNATURE-----

--=-y7gI+vpxTstX5MFQNLhg--

