Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37201 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbXLKOvR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2007 09:51:17 -0500
Subject: Re: [RFC/T][PATCH 1/3] rc80211-pid: introduce rate behaviour
	learning algorithm
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20071210090853.79ea4645@morte>
References: <20071209211547.2d7fca32@morte> <20071209211931.26ff42fa@morte>
	 <1197239150.7543.13.camel@localhost>  <20071210090853.79ea4645@morte>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-22R3Wke7s6nDBLedlpnl"
Date: Tue, 11 Dec 2007 15:51:13 +0100
Message-Id: <1197384673.4037.21.camel@johannes.berg> (sfid-20071211_145121_935363_5BE39ACF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-22R3Wke7s6nDBLedlpnl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> After a discussion on IRC with Michael (Wu), we came to the conclusion th=
at
> it doesn't make sense for mode->num_rates to change, because:
> 1) if the AP drops supported rates, it'll drop the association as well,
> then everything here will be destroyed and created again;
> 2) that can be changed in userspace, but we couldn't figure out a scenari=
o
> where it would make any sense. Johannes, any comments? Wouldn't it make
> sense to just forbid to change this in userspace?

I think I'm out of the loop. What are you talking about?

johannes

--=-22R3Wke7s6nDBLedlpnl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR16j4KVg1VMiehFYAQIdpw/9F4TEEFw9v+YPmOBTurJGhSqTBWBf6O8w
XZ1lipeGeJKy/38Ya5zgmerfJCmjFaoyZMPlbsWJhw1kjIHXrI2btuGDC4FDl2Sb
ps+hSgA9aTwteisrzRorGFb1wz2OOu2dSihYpwnHMsA4uBeib6LNbuAhzFQEd4eS
7HUBkFzlqdOEIDBsP29FrV4ZG4hwkBzmcEHrdA3r/ShFvTB0Qr6a48sxGzOMYga6
Ff+MBrLgg0G81TNTZ4yWnwlaiSkEv/MI/nrfdCXLWIZQ7Ec03svpamyH3ZM4RvTw
V3lp2p7uNAkwgjvqW8wnguLVxd3fqJxlDE5J5fRmsob5HnzSMrMCXXze2HL2nn9K
EI5D5UyXRsV91RNztFuMsAbzJbzePSAf9q2h5euQi0JqtvkZ7L/BWLzkL7ucRNoG
SOJsu2HlpgA18w1ApO/EqwpvfYO92lEgA7jZIHWKbjEw5Sb81iWx8dgKGhDH0VTn
u+FnIpxD6OGLKPtWKee0HyKzj158tgFGg/yTjsv6RrOMT2UmqbHkBQxFbeyqOm82
ian94Kd6niOYIrLPbxE8MMi1olzTuMAIpiMINuKF5jId2KAnwYuIt4067ZD9Mr8z
PQSIV0zks89yYaGSFtCQzHlLJOzQDLKvvgqjFfx7W/8Tny9wHPxBXGhlzNkSI2iu
orU8898RmIg=
=bjqV
-----END PGP SIGNATURE-----

--=-22R3Wke7s6nDBLedlpnl--

