Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33999 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbZD2JwU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2009 05:52:20 -0400
Subject: Re: [PATCH] mac80211: tell driver when idle
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1240997537.593.35.camel@johannes.local> (sfid-20090429_113258_830522_7A916290)
References: <1240997537.593.35.camel@johannes.local>
	 (sfid-20090429_113258_830522_7A916290)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-NIz+1uhNBBDQHeuUF7KL"
Date: Wed, 29 Apr 2009 11:51:47 +0200
Message-Id: <1240998707.593.36.camel@johannes.local> (sfid-20090429_115224_281059_8EC4231C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NIz+1uhNBBDQHeuUF7KL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-04-29 at 11:32 +0200, Johannes Berg wrote:
> When we aren't doing anything in mac80211, we can turn off
> much of the hardware, depending on the driver/hw. Not doing
> anything, aka being idle, means:
>=20
>  * no monitor interfaces
>  * no AP/mesh/wds interfaces
>  * any station interfaces are in DISABLED state
>  * any IBSS interfaces aren't trying to be in a network
>  * we aren't trying to scan

Please ignore this patch -- it has a small locking bug.

johannes

--=-NIz+1uhNBBDQHeuUF7KL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ+CMvAAoJEKVg1VMiehFYfMAQALvQiW1KvLqKlnqbm05awuzK
gAbOuu3V0XR9b230rfW2VZJV4iqnysD3G5yFGXKY76RJuREsPhvj3sGAtgNKNQOZ
jZeLRPjYoI0G9xC3AsT4hIB1ETlHQ1g7g0SB0SoAhlWbXL2L/XP5wKjxya+OSQF8
2LRQV+tUWsS0czEunTGAmEp7nZgUQOY+QpmHYw8PYPpJoQwvK+lZM7P5+nSAXflr
u4jhX9AKXM6CsBmxc3iUzQ44Ubw0eD5iI6VgGurLBtnMA1vUaCJZftZsLM4Exxdc
jHXASWrkHy8QsowtRKrwqvr/SV2HmmQmdyEEvtP6EUvQx83Z5M1NEISQ7AfygqgH
eyjnmUiafhuSM9lzIGF+krJ6PjIGYIkFkDIGO/GUNyQIa0vR2jE0UBmZJDSDPHYQ
oLcdZbLGioyv3kWiBZkC84eoiHd1YY/riszK4t2szekdjPtVW8HaRXYVSxzAszrN
qoxc8V3LtwS7TZE+KYPgx+bzE6dT+syzTC6mX0mybfx6Kj8RCpxEr/rtKpIrskPG
tMXTJcFkxZO0GyIe0jX3hIHjFL+e8OhbAdvT0jr/v5n/9Nlc3t8Vj2ZZ/o/HznUk
PC3hoiAAT0qk1RoewoVQLeoyowot9Q+uhkPejqlj75YTdjHjdLM+bokMdOnUJyCq
I499f+dXXvPMHGVnZQ3W
=AHfw
-----END PGP SIGNATURE-----

--=-NIz+1uhNBBDQHeuUF7KL--

