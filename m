Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45096 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbXJ1KjA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 06:39:00 -0400
Subject: Re: Change error message for failed rc module (was: possible bug
	in ssb/b43)
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <200710280034.41942.mb@bu3sch.de> (sfid-20071027_233701_549220_BD0E4B1B)
References: <4a55afb80710271456k6c3bbfeah879b67a91a3b8d41@mail.gmail.com>
	 <200710280034.41942.mb@bu3sch.de> (sfid-20071027_233701_549220_BD0E4B1B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sRwjwyTdUoqLuQMV+3IF"
Date: Sun, 28 Oct 2007 11:40:21 +0100
Message-Id: <1193568021.3966.15.camel@johannes.berg> (sfid-20071028_103924_982706_8311BD91)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sRwjwyTdUoqLuQMV+3IF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Please compile and load rc80211_simple.

rc80211_simple is so little code, can't we just compile it into mac80211
module and make it configurable only for EMBEDDED?

johannes

--=-sRwjwyTdUoqLuQMV+3IF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyRnFKVg1VMiehFYAQJy0Q/+Nyz+LcuQnLjZ/dWCf7hkOQYxziD5yL/N
cV1ABVufNOYodJ+vzj93HTrnYGZC9BXYMfm6C64bXC3kuilerHQ1OBhlyFuHvboN
rQFhmPxUmvmKxd7XcQf7OXu/aIL8IPT8i4Wb4URPc8HwS1N6cQ5esCYXPzR51EBM
aZjLy70T4ZcdFZxU7efTnre4VCmeO128Pxuv4jDZbBz5ZEq2IsQANKi6H4xEtolx
eXHp/RLKZAu0hSrxCFqzWbXo9SUqEC9DVR7w6FaoE/DjLeB1+uMurJVUsUlSryPL
ebw97FB59zwklDFPJFi++0+RdVVSg6fKVEsEBmfiHlppomqm5GWeyW7DtlohF7lO
c2UxVvwPRN7vmylXWTzLFftUi6yoi1wIwzipy8wQWyCjKD/7cBt28GeT74YRXcEq
8UIyBDhbE+bMqvL1/i6h+/E5SbJ/nGunF9qTg6n1swEeP5kV6xppBf83jYZCgMTS
FhofHKYyUKBSzJijjrJo8yIgIKHSRV+SKis9NXqYjuSpBOFej3TxP7CpeSZX4q07
lx7RG0pX0e0apsui2Lzl6Y3avbpL4QOOCU2I5Nae7TXmfgpO1MfbM8Ws9QtGVAnI
Tia1o3z9aBjUHP41t2Y92gWhWO5OaAVj1yQncMuFHTUjmEgpHNgnUZwJnJ4ISUZP
WA2Pazsa3YU=
=YalW
-----END PGP SIGNATURE-----

--=-sRwjwyTdUoqLuQMV+3IF--

