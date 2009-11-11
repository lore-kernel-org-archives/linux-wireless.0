Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33844 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbZKKLey (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 06:34:54 -0500
Subject: Re: [PATCH] iw: display noise level from survey data
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200911111212.48904.holgerschurig@gmail.com>
References: <200911111136.34949.holgerschurig@gmail.com>
	 <200911111212.48904.holgerschurig@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3nR0ahDZbhyyYA8k7ZdY"
Date: Wed, 11 Nov 2009 12:34:26 +0100
Message-ID: <1257939266.7037.97.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3nR0ahDZbhyyYA8k7ZdY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-11-11 at 12:12 +0100, Holger Schurig wrote:
> This no longer works against wireless-testing, because some=20
> NL80211_ATTR_SURVEY_INFO has changed the number from 53 to 54=20
> (in wireless-testing). So before/after appyling, nl80211.h=20
> should be harmonized between iw and wireless-testing.

I tend to copy it over before applying new patches, so feel free to send
patches w/o nl80211.h changes included (but I can deal with this too).

johannes


--=-3nR0ahDZbhyyYA8k7ZdY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK+qE9AAoJEODzc/N7+QmaoiIP/0F8IVUjjmn+D3GujcP3NEkb
hFJXbX2tHhvi5f84ICZ7Kpf8K/5V4aIMRJw/Jyw/+EPFPmC5RXeT7Tg+La/bN1GA
0pfzTQmtCQNxwcP9sK9+ogTsVzMIr9LwGwaK26XM+7rdrwOP+LpDsV6ggIGum7dc
anC4UctGeX/F1k9sh51efzxmLwzMaOH/zdTTRf91QBk3Ft6lPaghKxjW0nsByyEF
NLqoQE+deH5vNKuRWyiRlSCh58dogsOT0PmLF9VXO4yyYf2luJH9jy6yfzNdYBZ1
tcZkRdtHZOTr1tIO2rMOL0uXxvHZJ9lVwlT+Dqm7c/2Fvv6YK4LBJVeKhEAHm2fV
D/huRMyZYDFu97WVQThW2TFLwME6TBY4hpJ43+9u+NwJi2/OcWw2yqkJSwUrmFbG
LoQDrXU1eNmDZHwFKxF6S5JO59Rfw5CKbXvUosyUXgge/nU89SbG0ZfCSz3ZwP5F
NR1jhpYHO+yzlayH4cQWYAwddA1hyNfO1jBNg9lXvKk9ZOuj6rQKYnWGrxXmk7MI
2bIAoND7DZJ+ftcPCH/pu077JY7XiVP5AXpxtb630Mj3Cxwpr39f1OBQ7wxlQ6Pg
JZlEwyDRUkqj2m5QBPa7mrIjic+09CECG6u4bjFOSWjoyPbK4oM9yGWqL6vjf2ds
9APPSwzQMgfubNQ6UCnw
=9pfB
-----END PGP SIGNATURE-----

--=-3nR0ahDZbhyyYA8k7ZdY--

