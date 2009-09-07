Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40427 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbZIGQbB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2009 12:31:01 -0400
Subject: Re: [PATCH] cfg80211: add missing #include <linux/kmemleak.h>
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
In-Reply-To: <200909071634.33669.hs4233@mail.mn-solutions.de>
References: <200909071634.33669.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8pU4duCe2JJz0XoJ1X61"
Date: Mon, 07 Sep 2009 18:31:01 +0200
Message-Id: <1252341061.1175.41.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8pU4duCe2JJz0XoJ1X61
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-09-07 at 16:34 +0200, Holger Schurig wrote:
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

> +#include <linux/kmemleak.h>

As we've been saying, the change that added the kmemleak annotation
needs to be reverted instead.

johannes

--=-8pU4duCe2JJz0XoJ1X61
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKpTVCAAoJEODzc/N7+Qmai2gP+wflCubZjLsV1nZC3WPv3Mzy
TAlsFj46uJdTInrZFBXrRJ5YqRg1YqbMhT7yZMJuIXL8pByxhFEq5ihgcGmlMrJ2
71tpxWbSQ/gp0VWvKihg934on2z8uN7EfqVPQGFCKCYleFqT1JjKk4/Yd6AY89M6
sVG8r7yFmkAUbdI4+x0USrdK6vB+u63XQpUwOAQ+TLBmngBHpXtf5Gybisq7lFgM
d+/KQ2jMF2kV4hCpQ5oLvqa+lP3y4epNa5UH8CR7T58efxzuJYpNY7BIyy/Dxuv+
pzRgx5kKwQL0hqu8t6Xclou/JWGT2/yGy9voXaeXG+GbEVtfPdF9Co5FCfHwRDhC
Zdvbe0UDvVYvn9k/JQLFyVzRfEuB+6jUHk6MYu57Pidn777E7DtOLRbHyBWpkLRf
YfOtJ2EOjh2CIdPkoh1wc9tZB8C/JtJv9hTG5KQALs2AIE9pOtTdWWUTTu/LM8bw
c/ca+ekEi0BqHQ/jXP3sPpNJGmacGmc4el7iM0icClKkK90zzc7IQEmFDw9zB+Cg
Et9QfybjWl//tR0exAF5mlOIUoUfxwTwpYiQrM8kmX58jKjTvPUmvpm8YDfYkZRq
JA/Hqr5mr373jH40hSLDH3niQHmn+3WQgF+OW2LxxuymtLd4nDCtBQRMsR9xVeeP
CZ00vvcW8hqDsGbm7tFu
=EH6X
-----END PGP SIGNATURE-----

--=-8pU4duCe2JJz0XoJ1X61--

