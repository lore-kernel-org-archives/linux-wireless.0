Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60930 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbYE3WiP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 18:38:15 -0400
Subject: Re: suspend vs. b43
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200805302319.34173.rjw@sisk.pl>
References: <1212150713.4117.2.camel@johannes.berg>
	 <200805301720.49327.rjw@sisk.pl> <1212162163.7238.1.camel@johannes.berg>
	 <200805302319.34173.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-URCOGOqEgJAMHAhoLXWR"
Date: Sat, 31 May 2008 00:38:10 +0200
Message-Id: <1212187090.20421.2.camel@johannes.berg> (sfid-20080531_003818_867382_F15502D5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-URCOGOqEgJAMHAhoLXWR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> It hangs for me either at read_unlock_irqrestore() in b43_op_tx() or some=
where
> in ieee80211_tx() (at various places).

Huh. Why is it even getting into the tx path? And even then, why does it
hang at an unlock?

johannes

--=-URCOGOqEgJAMHAhoLXWR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASECB0aVg1VMiehFYAQIsGxAAqaxGdsLhRTg4WuPkatJLFrlVtrntPfsC
9X/dIdQJK0010AgEwO3wucVWy+rfD74hcO4qy6WA50X2aNvwytsmw6F/XKWmL9dZ
zHqsJO2zQnIgr4w91LaxNANur61SnhSbFAfKB7mhzNxkwUAAi2tuenKX5WngEYmG
vvSQT2GjuGf2ohjA65+KykRF4RB6YrlIDNU0x/gjvpw3FkDoFopkFgQvRMh/xuhy
tgS6ZEm4+s7dCBhvS4Vu8ts0CamGd5VKba+gkYyW66Jrh+79uJtWgRbpnKUMzTjF
85E4djgam56psHoqqmCRLQFBkyxm7FU/DHooNvi1WpGsGMTf+kTYG3HtUKSIXo3y
jVq41NXKmR4MioAbjcc2TCCKKiY7McqY8RZW7byuFMM5RwrIDek8TTQcVH9PLNrN
IgmmbRNfn+L2/Bvs83jtnsY0ICq2mzWvkp94zjEgFKJoPvbal7bTyuschsAu/Qln
ME/dpnczX4QQg2CoQW1bT8uUVKdX4csbHn+kwCb0pjfSen9tNrCKEMEtWvhLViwF
vjFaaF0WW6K7bhoVyqecrw3acHT3EZSU9gNdGabuFW9HJg8AENcqb1Uawmx3YcrQ
G786Z/QGAImYDaq2stEetI++E8+buJPH3Vi9P2Q1Fvgw4q7wM5ZXOVMtpwsPw9HW
oQk5F6S4GN4=
=ktJx
-----END PGP SIGNATURE-----

--=-URCOGOqEgJAMHAhoLXWR--

