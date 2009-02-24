Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42657 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbZBXNtr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 08:49:47 -0500
Subject: Re: [PATCH] ath9k: Add module parameter to disable hardware crypto
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090224114201.GB21933@jm.kir.nu> (sfid-20090224_124211_250628_44CBCB11)
References: <20090224114201.GB21933@jm.kir.nu>
	 (sfid-20090224_124211_250628_44CBCB11)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/Pncri8LHPkc3lNVGg3m"
Date: Tue, 24 Feb 2009 05:49:07 -0800
Message-Id: <1235483347.4320.7.camel@johannes.local> (sfid-20090224_144949_685088_0B1710C5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/Pncri8LHPkc3lNVGg3m
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-02-24 at 13:42 +0200, Jouni Malinen wrote:
> In
> addition, this allows management frame protection to be tested with
> older hardware revisions.

This is odd, shouldn't older revisions refuse the hw key setup and use
software anyway? Or are they unable to distinguish between management
and data frames and thus it all goes wrong?

johannes

--=-/Pncri8LHPkc3lNVGg3m
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJo/rFAAoJEKVg1VMiehFYF2YP/A6YHozGbdBQQYBQZ3f+towe
rkuQBcBBem5mAQXlTwwnfQP/v3OFtipR0Xr6TGdP4UYMZ70fyjOW142DcOZg5JrN
hAYwrsf/+mszudKrp5WeWZhCiOD0J7MvXan/JVAyeCHwJVRJUl/f8HvN2WmUSjEw
8kt+3OOoqlbf4FFKs2S1CwjcJEcvSBTE6yoE1vZwD6uw6yT9M3ZjxS2XNIrYqcML
NlJYPxsl7IL+Us6zvn+MYLf8gm5NfqxqkqmhlaAZE6ENQzmqJARtinwCwRAuhE2j
LUZ71Dc0pl+28rLiupxcjGx6wshxYtLZQOFSGO/Is9B9tRNwTd6xoOuOsmkt8n7O
7JuKusGGahkd9JohlBOv9VqRNWkZEWZ0eh+P4SyAN4l3cDVnTF4hMbjaLXVzRJph
ACPTy0K6utm52a0kNyrJAVgs8OSqRHJyk7iXJsqK4ITtnKjUfgAUCUMQ9AN4vwlk
bc85MIhgyfLJo6nUV8X+BS7oTM1jDlIz30aFDCwy3i4S7gSOoLr92hhI8iss8y02
3yC7XZDgu49BpXXp1KLYtAUPhFH9E6Yv5FSlhuoR5NoWw4Sh7MAph/2RjjJJiNll
46A+fdoWY/NSwVZV1hFZSNvm4Pr9aJVwB4cTREWLQ3/+GrhNUZFKNYdTGwalARpR
hKAeW0goVGXBeKeTNYao
=hZ5z
-----END PGP SIGNATURE-----

--=-/Pncri8LHPkc3lNVGg3m--

