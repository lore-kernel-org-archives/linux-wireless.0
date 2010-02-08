Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51298 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab0BHNse (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 08:48:34 -0500
Subject: Re: [PATCH 10/10] mac80211: remove get_tx_stats() driver op
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100207082201.31474.98843.stgit@tikku>
References: <20100207082044.31474.48583.stgit@tikku>
	 <20100207082201.31474.98843.stgit@tikku>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EbaJpttZze5pRNVKwise"
Date: Mon, 08 Feb 2010 10:25:13 +0100
Message-ID: <1265621113.3783.5.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EbaJpttZze5pRNVKwise
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-02-07 at 10:22 +0200, Kalle Valo wrote:
> get_tx_stats() driver operation is not currently used anywhere in mac8021=
1
> and there are no plans to use it in the not-so-near future. So it can go
> without anyone missing it.
>=20
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
> ---
>  Documentation/DocBook/mac80211.tmpl |    1 -
>  include/net/mac80211.h              |   22 ----------------------
>  net/mac80211/driver-ops.h           |    8 --------
>  net/mac80211/driver-trace.h         |   23 -----------------------
>  4 files changed, 0 insertions(+), 54 deletions(-)

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes


--=-EbaJpttZze5pRNVKwise
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLb9h1AAoJEODzc/N7+QmaLc0QANAD+wP4tWDr9Fq6Dri7R3QZ
kCI1BXgN7pUPsBQTR4kpjBUjEh2xxlYgcnbafSPku2o1eJD5NTVJbUcm4fYcRRmH
ehlJTX+Zg8kvtt9vPqVynQtboA1ff4hUSfD9pKOYpDHAuC4Jmq6j4buCSuMNbs6J
q3EG9vazgp77XuPY3yQ45AtuWrGPC/7FBr2nGNF25kJDUI7y67NXKXRBSucuZYof
veB+6yc9A6FqsLvBzDQYx5XnhKHdKnrom2i3onur0ommmjUhWSOr8t1gNO+HQNxm
Jt8sRYlN8hljfX29APJ1H3MOCR6uo2R9+m1PCij816ELUdBFR/W3UMm5AGB5pY3b
7xRFN7nLw4ct8WOctGBPuLUf29u6WAoMUbeXObFqhyYoJoUzmV7pIF+5gh98rLyX
J4HozPp1HKLHJrp8HdwXwhK/r3cQrc6t71y9thuiGJBSQxpVfBk+QZreJVGmaPST
TBHEj+SaFHBe9stvEGmiDUcUViLLmO6inc2vasr0EFNE1tEOSXQ4JguDg4M/CyZE
xftIu8Xon9T77lm4NccotlzKJ56QPMrkeuodlIh8jchveEN2n/F8ukuO7HoOcHem
eEbF0wcmEbFHt64Gx62qvg0hXn0EkhlC1qnRtCi7jRaSKhHeQlQsMoLwYNuvuCeC
INaiu+Hh4jb9T/7VL0sj
=o5hc
-----END PGP SIGNATURE-----

--=-EbaJpttZze5pRNVKwise--

