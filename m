Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44242 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398AbYHaJoY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Aug 2008 05:44:24 -0400
Subject: Re: rt2500 probe responses with wep and fragmented bit set
From: Johannes Berg <johannes@sipsolutions.net>
To: Eric <plukje@gmx.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <48BA50CF.9030601@gmx.net> (sfid-20080831_100555_737564_C99DA302)
References: <48BA50CF.9030601@gmx.net>
	 (sfid-20080831_100555_737564_C99DA302)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-r1HM6vTT9phe4/oe2WeW"
Date: Sun, 31 Aug 2008 11:44:16 +0200
Message-Id: <1220175856.2378.0.camel@johannes.berg> (sfid-20080831_114427_884529_8CB13020)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-r1HM6vTT9phe4/oe2WeW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-08-31 at 10:05 +0200, Eric wrote:

> When analyzing the actual responses (tcpdumping on the mon.wlan0 iface,=20
> using wireshark to disect), I discovered that the probe responses for a=20
> SSID broadcast
> had the WEP bit and the Fragmentation bit set, consistently, for all=20
> probe responses.

You were looking at the wrong bit, the radiotap bit, which has little to
do with what gets actually sent.

johannes

--=-r1HM6vTT9phe4/oe2WeW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIumfrAAoJEKVg1VMiehFYdGcP/RJui2h12uSI4o0D6bsodVgw
z5wsK21oZbyO3rU1thDbCknwt4HgpIFPNRxH9C/hyY9l6kxkt80k6f/4BGJSRpwL
Po2G8TI8JpACQUgJTC4l9WzJT2zpDBBlMB5cVcb1NYGh2u6Mn8hiEcclEPTvwbIP
IurXsI1mehQR6JTRGE6ZbiRmjNw9aSGwj9CFgq+ahqwI9yaJJwWqHgl1JnZdsz8j
VRnLD0QAXydcBEJ+mcxHl92jfqRIRu1eNUxeWgYYhMpfN2e4ksHmFz1aS7Kz4AY2
Jlh+dzp467px6PnrvF20ll1GGHY4buk1UaR8b8L+qVCnXhllf4J7lj2K8hStrQaR
y/tlCR0ZaGuXkf1mwjqk48vEpoUJvoSNEGCrCT4EhPJ2olqyZpFBuZb1HL9yUGNm
SX54HJgbz/bRORjT6ksnJeqoGHGNlQClJaWPlnc+fxprwktRWxLPl4JEQ55C8lWV
v0zfGCiQhVYKnlzb+inRzEbNpNrPdkfnm6WA5auR5yvMFWjv3JsBP2etaP7xurqt
C5zH84ETv5X8yDVsB7Zw//OGX0mtw/A+Zk9e2hOR47ZKSMv3o8XePVOiUokfPqvj
9k8/7VauNJCMEJOsh3Zfsr831QhrAqN1RmxM3joygUP/fjliSmJSgRmoQwjsRw01
zriHZs+n/R3TA1Kx+ouc
=1o7I
-----END PGP SIGNATURE-----

--=-r1HM6vTT9phe4/oe2WeW--

