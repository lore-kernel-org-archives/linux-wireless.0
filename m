Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38651 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbYKEPuF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 10:50:05 -0500
Subject: Re: include/net/mac80211.h:405: error: size of array 'type name'
	is negative
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081105154049.GA10264@x200.localdomain> (sfid-20081105_163747_744831_98B56797)
References: <20081105154049.GA10264@x200.localdomain>
	 (sfid-20081105_163747_744831_98B56797)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4kmHHvQH3JdYGMsROA5c"
Date: Wed, 05 Nov 2008 16:50:07 +0100
Message-Id: <1225900207.3619.123.camel@johannes.berg> (sfid-20081105_165009_838364_B9827F4E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4kmHHvQH3JdYGMsROA5c
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-05 at 18:40 +0300, Alexey Dobriyan wrote:
> As seen on various arm configs:
>=20
> In file included from net/mac80211/main.c:11:
> include/net/mac80211.h: In function 'ieee80211_tx_info_clear_status':
> include/net/mac80211.h:405: error: size of array 'type name' is negative
> net/mac80211/main.c: In function 'ieee80211_init':
> net/mac80211/main.c:957: error: size of array 'type name' is negative
>=20
> whic is BUILD_BUG_ON wich suggests something with u64 alignment.

Thanks. It's actually, special ARM u8 alignment. A fix is on the way.

johannes

--=-4kmHHvQH3JdYGMsROA5c
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEcCrAAoJEKVg1VMiehFYSPoP/1o8TkzxspkQYvNIV7YRAqTW
/GxPOh2kY7lXB/Sr/L4uCTjNu/Q865h3cP5uqESF7K/FxBBqXuwmlASHQQ1HI8H5
fGv4U1DO7SnDGzEi6XPfW2+X/7X+QCwRKjcgOu9J9h1Qjm2AFSCsVQFTpAbMZEh8
Wls2LZYkG26/SoW8ea7rmP8Xt6Sz4qbP3K3BB+wVS5J06OuSsVawSdWxnvFnCJio
JtpyedHWpzvNYAfyzPN1RDnxU2YZyZRbdGpm87OLAEVvbb3A2IZQS74fW4c+C0aO
xhn72yJd6ABklCe4BHHNIvGDLJH471IwAe1tXlRAD2IPgnK9r0enRolOnLJb6CX6
T7GiLrvWGIXYsxdX3bvbA5FJkQvO1ImQkTkWnTIQ+9xPAWJP4vHtTjqZb7EszB1t
nHlwvs/JddCYPs1u3nf+AgnyAxt6JGh/YG3XKdgjZ85Bh816kXxjmx2HkEetnkEv
OloO+g0TD4lfTSfkLoL+xr5I0Uz9cS5JIYB9SpFuuDg3LTtRnC5AuK4qs19b8UIC
ZTBk7R/K8wQ/aejoqJl6cBKRCALSwV5UP0WQ79k7Ch5sxLSMPV0XQo+Jh6b2ix3/
7Sda1GYLiKdgKMWpBbDTRvCy1nWZcGWscuvIhjU7jtMMoBlrSzy3Gv5LNBPBNpq0
il0LKEUKs/ov1U3WnjTR
=BH7I
-----END PGP SIGNATURE-----

--=-4kmHHvQH3JdYGMsROA5c--

