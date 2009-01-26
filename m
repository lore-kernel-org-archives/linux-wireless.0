Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57607 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbZAZVUI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 16:20:08 -0500
Subject: Re: [PATCH 3/6] mac80211: Modularized mesh_hwmp.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Florian Sesser <flomaillist@cosetrain.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <e236615740b8ce8c9515c14aac3a2d9d93806a98.1233001802.git.flomaillist@cosetrain.com> (sfid-20090126_213927_189051_52B47541)
References: <497E1B90.4060803@cosetrain.com>
	 <abd4234c03d59a65d3eb9259821d705899a08612.1233001802.git.flomaillist@cosetrain.com>
	 <3202b18e8531aa78c29636c163de20875ae1a9cf.1233001802.git.flomaillist@cosetrain.com>
	 <e236615740b8ce8c9515c14aac3a2d9d93806a98.1233001802.git.flomaillist@cosetrain.com>
	 (sfid-20090126_213927_189051_52B47541)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ea9HgFoOXAFA01el4FS+"
Date: Mon, 26 Jan 2009 22:20:04 +0100
Message-Id: <1233004804.4533.41.camel@johannes.local> (sfid-20090126_222014_900346_A4520708)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ea9HgFoOXAFA01el4FS+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-26 at 21:39 +0100, Florian Sesser wrote:
> Separate mesh_hwmp.c into own module, which is
> loaded automatically as the default path selection
> protocol.

Let's keep that built-in so it doesn't all break all the time. Kconfig
too. Cf. rate control.

johannes

--=-Ea9HgFoOXAFA01el4FS+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJfikBAAoJEKVg1VMiehFYYCcQAIXGtfCKfDdFjsH7HgoV6OBS
CxELGDKjtIkku1+8AEfZlOJI3AbGxQ8MNxtS5+xu/r8mB4bnxN9q24yoqwhzNkYh
PBicIjngOGiRgsxBVN+bx4IXuC9GmXSIjpJZSfde6VwKXHWTmIeh+oVZhxfY4n7j
VzdCPDgRYKV0ijkbfa+p4bckmOnhD7j+Udd0BHn0Ek2Rk9GMNCmypichywUQWiTb
H/nXGVQx66be36Bm+0CrnG0fmGwrBozduTillqOzTEylhXfcwQWjwteu/xWE+s6Z
aQb6dk52TdRvIHFqdy41vPEUyNVAb9NPWnivPlIQMyNI4fP2iZD6MI2EXcPuOsxs
8UyYBfRNpzQq2UAnKZriPimK+n21XQJCOk4jJna0qB2VNYBkIKtOXNRGhBhn69aL
0xkFjuyRq0P7Xf/NIXO8URa/rVzBR42+XmiGRGww/nLZo5Gnbyw/mr+jgDUkXR23
Csju6/ZCSBkuqNNJnf0Li52QMc9zKV/8w2iDrSOavetnBvzixNoYqjHKGDW9XNvP
HyEQK1CiZvs0oCA7sGCTlJGM1ut+zQo6dVZnSQlFv+kA0pAfE3C3XVg8riEKWAQl
8OTNfMTqEvXwZO55QQBH/LDjvZoT78q/q01PMdHYKp6qqBJ1swOqbZzVxK0UjFO/
lVXiSWZNXQFNYr1pzF/o
=qDzJ
-----END PGP SIGNATURE-----

--=-Ea9HgFoOXAFA01el4FS+--

