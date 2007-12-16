Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51990 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364AbXLPSu0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 13:50:26 -0500
Subject: Re: b43 problem with led trigger registration
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <20071216180006.GA3606@tuxdriver.com>
References: <1197822019.4138.2.camel@johannes.berg>
	 <47655E26.2040309@lwfinger.net>  <20071216180006.GA3606@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UzytAhEidPoxqQWwluld"
Date: Sun, 16 Dec 2007 19:50:08 +0100
Message-Id: <1197831008.6769.11.camel@johannes.berg> (sfid-20071216_185028_203219_3C9B7284)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UzytAhEidPoxqQWwluld
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> There are not any new mac80211 patches in there yet -- does your fix
> depend on a pending mac80211 patch?

It shouldn't. There weren't any relevant patches to mac80211 that I'm
aware of.

> FWIW, I don't see anything obvious in a quick code inspection.

Me neither.

> I presume that Larry and Michael tested this on the previous iteration
> of wireless-2.6 which was based on 2.6.24-rc3.  Any chance that
> something in the rc3->rc5 difference accounts for this?

Probably. I think lockdep might tell you where the atomic was entered
but I don't have it on this system.

johannes

--=-UzytAhEidPoxqQWwluld
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2VzX6Vg1VMiehFYAQK3CQ//cfEkoDkEkhObGSwmHOWTFbPZO+38c5qt
GtmQ4Bm/2VxoH1qGIzgVasKJcTlGfZ305aQx3hDspTfp+0+ZxQ/kg8nha8c7mhI/
eUhjxQxqY/fLjkB+kgyENDdq2D1iXoGL+BG/FvSlTo6hJmqxwF1CiQPJe0oBdq2n
3lZ4aTUvI3ZjRkEeZkX/DY9GYedXPr3nU5SXaXphNwe/IMeJAfWo+LAbdud27xrD
HeYFLHFwDUoVUCXK+5R7hu9/jp0N3biwb769PqP6I+S9F4+kNAoSXWkGqigp/e6z
75Q2FPEBkbuzlhgPtmgo0mcdvHiSGcP5GDRrXa8DtFysInJDd9j+IySN3U3mD/+z
uoJkDBss3h8dFOU690AYQdX0sb1VKR0ZzbERL5uzt3HRxPiS+QlCwbhO7AhLjbW8
rtV62XZ8W2l1qkFKRe49KKg0FBqxOAX05X4SbZbHsIjLdv26385rLA+PT2svkjKJ
5d4WHUpUqsZRxLtEeTF/NEg0OL4IoNILSZneHfzckqfR+1QuywyrblInCaa4Lp+m
J3FQeU75SRENjBLbNFwXtEL1CtqBee0DUEWTig5ZEX0uZKOMgURhZG6vPVXQ2teJ
viixRH93Al8GhH7+FpMx/fKurLCF9+6P3ulSIXB+F8S374I5l/LORuLWAd9oEG3f
20H6wt27XNE=
=Wi3g
-----END PGP SIGNATURE-----

--=-UzytAhEidPoxqQWwluld--

