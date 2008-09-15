Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43112 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbYIOIvx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 04:51:53 -0400
Subject: Re: [PATCH] cfg80211: clean up regulatory mess
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1221468326.3700.29.camel@johannes.berg> (sfid-20080915_104537_374315_FE9CA10C)
References: <1221468326.3700.29.camel@johannes.berg>
	 (sfid-20080915_104537_374315_FE9CA10C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TPlF7nVKQM8oFZ+fO1Wo"
Date: Mon, 15 Sep 2008 10:51:49 +0200
Message-Id: <1221468709.3700.31.camel@johannes.berg> (sfid-20080915_105156_168811_A280C567)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TPlF7nVKQM8oFZ+fO1Wo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-15 at 10:45 +0200, Johannes Berg wrote:
> The recent code from Luis is an #ifdef hell and contains lots of
> code that's stuffed into the wrong file making a whole bunch of
> things needlessly non-static, and besides, what is it doing in
> core.c??

Sorry, this patch is bogus, I accidentally moved code to the wrong
function.

johannes

--=-TPlF7nVKQM8oFZ+fO1Wo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIziIiAAoJEKVg1VMiehFYa9cP/j5MXXcPaa1w7u4rvkcUB3xS
0fjfBZmkobih/jZl0ipd1Bih3iocgF6PYSRZzNy6CIzd6J0FQSK0eyrO74wf5hTh
yOf4hYihGjWe5A4s52WZSQVsP1o1QcnfaF1UPCYz4BPQ0VT8R9aD9QlM7JIfclJO
jKu2bwOKdiOcTjYwvS50OS1Rzs53/KO2pVrOuVcJLPBDsQltoGiyVAo0J+659iK6
p8Afr+zFVFRft1KYCE1efEPLPZGsSqlOKR2kuzfcJZ88ruWEjiFTskinpA3rWuOL
6h+/UCawAvt+VX2GYwUfG0pdiYR+okXI85CkIlcJ0tsiXtXowEafhch6bTuZf9og
ShCX9S6bVcWclLDTQKlNxjrj8feey4kz5k2OAk4p8jXaqhvb6nX7aDBHu+WsCYll
piwBCDQ32sC7RpD1zisrx5NpphQSocYlG1oZLgKThytv/FZN5E15sX9QAPb+V6O7
qTtjdEx68k9YRSn4UJJCtAaRkdBaEuFkCpzbAJNm7gJd+sZ9LwsHqg3eWh2qi869
ZqdnY6T0JZQt05zj7o8Q/+JwWaLTT0vf2quLT55MLNJMB9d95XiTZyC/a0ARPVU3
lJzmEEzj9krMpc8zW86DsluXYIJ/FOz26suGlG3AqtQNM/JQOi6HqaGXrxdsAHdN
CYg6nIU6UZgmobWDFecX
=FntA
-----END PGP SIGNATURE-----

--=-TPlF7nVKQM8oFZ+fO1Wo--

