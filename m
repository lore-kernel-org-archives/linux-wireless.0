Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47952 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbYK1JdO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 04:33:14 -0500
Subject: Re: [PATCH] wireless-regdb: Update regulatory rules for Czech
	Republic (CZ) on 5GHz
From: Johannes Berg <johannes@sipsolutions.net>
To: Carlos =?ISO-8859-1?Q?Lau=E9?= <CarlosL@seznam.cz>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <856.1518-15019-1010599801-1227831093@seznam.cz> (sfid-20081128_011149_075177_C977D6E2)
References: <856.1518-15019-1010599801-1227831093@seznam.cz>
	 (sfid-20081128_011149_075177_C977D6E2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LKxZ2VIpAIHtpx2NEkFC"
Date: Fri, 28 Nov 2008 10:32:16 +0100
Message-Id: <1227864737.3883.0.camel@johannes.berg> (sfid-20081128_103328_399318_918CB877)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LKxZ2VIpAIHtpx2NEkFC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-11-28 at 01:11 +0100, Carlos Lau=C3=A9 wrote:

> OK, I thought we cannot guarantee the automatic power regulation,
> using lower values for now, it would be nice to implement the required
> mechanism to assure tx power regulation, but then how to define the
> two values? two tables, or a flag like "NO-APC -3" indicating that,
> without tx power regulation, there is a lower limit for tx power?=20

No, it's not that trivial, needs more thought and a db change.

> And the patch:

I think you forgot something.

johannes

--=-LKxZ2VIpAIHtpx2NEkFC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJL7qdAAoJEKVg1VMiehFYzBYP/jopnC6dtUgaxnsHfZQLLQv1
/7TEabG/6cYcvGFO+bmTzhgPWuDaqRSWqEnam+aDaAHlbVSPEfAkS6C/3B/MFVCp
sXv7S22JLFe1RRva+0Jrv6JVBUslVPfDZupZ18vARZKx71TcxOEG75zLT/519QF2
7eg4fLJmA89Rx1bGaRwJfDQQ9dE1v8R6Llhb6NQNrXsioguGqKstt/vqvRRdutZd
LuVeZp+vOl60TRj/nySFkYAV7M1iUqci0Q6c3JAV7G8gxwK/IviuiAvXkuntY4MY
iJ4Vzhsmr64NTjjsVXVPG29zS3DymqX02Wblap3IwwT9biWH9+euh5LzMZRzQwzZ
XLLypQhSiRU4482N1oPwQP5GByLo8zFuUV0SY0yzBH2AitcMP5e0pWKkyMLiAaLy
oFQVv08QAcGn6VdiYcoHZtIC8T5eB++vGfM2AK4yM+FGJ0/KZKt0cMhVrONGTDYy
LV0fdy/WoJvQR1A/l5MQy3mM6STZrDgNchsQS2cCUOXMXQTIQ9ZK4DMReKVbVAVf
kUfERMKfAVuiaXpmvJvm1MLvrOmvk0Kg0p713mz/P1TAJAlQAydtB4V/OcGlZ7Je
qYrzJ+1pCeD1aFQudrLGKkKsxsuFy6hh8yEnHLUNDsRRnWkyCfoDqSgXqEtTWC9Z
H6uIq2t+hfI5DCFT+BSi
=AR5z
-----END PGP SIGNATURE-----

--=-LKxZ2VIpAIHtpx2NEkFC--

