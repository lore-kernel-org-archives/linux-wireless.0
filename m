Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37650 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbYAXOsQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 09:48:16 -0500
Subject: Re: [PATCH 2/3] ath5k: use SWBA to detect IBSS HW merges
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <bruno@thinktube.com>
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <20080119091821.31251.5098.stgit@one> (sfid-20080119_091818_265508_ECFA4777)
References: <20080119091759.31251.60264.stgit@one>
	 <20080119091821.31251.5098.stgit@one>
	 (sfid-20080119_091818_265508_ECFA4777)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fUQxh0pV+3mfFWnglchq"
Date: Thu, 24 Jan 2008 10:18:15 +0100
Message-Id: <1201166295.3454.52.camel@johannes.berg> (sfid-20080124_144840_153383_29049144)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fUQxh0pV+3mfFWnglchq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sat, 2008-01-19 at 18:18 +0900, Bruno Randolf wrote:

> time und check if a HW merge (automatic TSF update) has happened on every
> received beacon with the same BSSID.

I don't know who is smoking what (I suspect Atheros folks...), but
calling a TSF adoption a "merge" is pretty out of line IMHO when you
also describe some non-standard BSSID changes as "merge".

johannes

--=-fUQxh0pV+3mfFWnglchq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR5hX1qVg1VMiehFYAQJ1RxAArfOIrTSbV9ol/4NKFSAzvPkTh7Ha44pA
R31tEbqR2fKMvgOTdLZtZot+YRyNVvv1KnqXMl6/w6hPOWHg2aDfLgFhu5kClG69
FIhCKwnDqrES4j+zP0blRWuj1KbqiQ2JaGtcvwC8VhGuORuLLEMx5ygtWiqA2MIK
WE7MWfZnrHAhPjGh57rX5Ww+GPRSUvB81uOPBxIeUs7oCQ4hJ1R4drBBjKXNlB5e
9d6rYrT+cffA5IHyK7+zqMLxTI7M/ns+YTocsxouAiXhvuJfN6G2JCJJm7w5ADvE
O0ho5jpZP5TSDfmH/TY/pO6yAeBRLwfYYhYKl7rU6gcOh6UZYGEBgAdHP+QrybjY
B/+gOdx0ozMZ5aQ2UfJJkoC2lcGkqe7RwWgGPNrjJVwWw502lSbgfWjIHAYNg70g
+i8FSyVep7oQwjf4gwbBEWA8lPw/GR8syIIMvqfjSJfXyzqywnEwZ3Ed3/7B7Ll9
E/0+S3I+7AcgQymGeBHppINYlzk1nY5xke/njlAbQgrV7BscWXl0OEKLoUdNwgeL
Q3KYvZwNqlhe8/NK9S1JPuiNySJW8ok93Ldsm++8Ie2R1KND6lqbfc4YzoXYu9uj
0AMS0IvDg5hKsvJiwASmKVTlA3wTddMSkZSyqoIs4hf2dvy3SN538+cj9etJ9XH4
vhc1Iy0PiBQ=
=pdB/
-----END PGP SIGNATURE-----

--=-fUQxh0pV+3mfFWnglchq--

