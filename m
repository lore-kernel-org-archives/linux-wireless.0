Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54495 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbZCTKtC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 06:49:02 -0400
Subject: Re: [PATCH v4 3/6] mac80211: check if HT40+/- is allowed before
 sending assoc
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1237444886-24530-1-git-send-email-lrodriguez@atheros.com>
References: <1237444886-24530-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AZpcvHBoX8O4KlSgYzhO"
Date: Fri, 20 Mar 2009 11:48:56 +0100
Message-Id: <1237546136.5100.147.camel@johannes.local> (sfid-20090320_114905_466974_7C7C1B9C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AZpcvHBoX8O4KlSgYzhO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-03-19 at 02:41 -0400, Luis R. Rodriguez wrote:
> We weren't checking this at all.

The question is whether we really want that. In other places, we trust
the AP, why not here as well?

johannes

--=-AZpcvHBoX8O4KlSgYzhO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJw3SQAAoJEKVg1VMiehFY8GcP/1PDpIuk50mmlYCctbdhIFI1
y0OTNSDnjo/pxPjJYxOyTu8R5ILWAUavYBN4xxbtCreqNTSdZinnKcjhZaJFmz0B
hgXIKyBtV3frDb1sEklurvMbn56W3v5r0nEvkN7jLwc8bAOS73QncStaRXlkbdsn
45d2ZRqkAjzXgXa+UFbqjem4maHJ/tE4tf/AI3hW0HB4UNV/C/Y/Fwnnz7juolw/
waxdngh8BnPLZJJLSAt2jP8qAi3/vv89egwTuWmtReTKvOsznkdfw+RqscTHIgAB
CUzPpV0Qf60YKl2aHhc8Ydtmc9u9PJPnfX9EUf7HLNDchaV6VDn1w3YkbmSRYuEq
C8MRsT3UZYKgL54knDf3fRv5nF1MCaG0pB9S5sDBtg+ej5OtIa1CRboh0v2pkCfs
6FyfDsGLzu2C5/1+enbtRQxNwf0LEcYbvE7hzYkgGZsAsJPGgUKOrfLAIeimSaCZ
gujK2NE1G8FHn644x7rFviN02UgBZIohkQ+cL2rPuLMnzBONLy4A9n4RtAfwXFer
Ummpa4CkCKDSBolOtvFMooaoQrPC45yDerkYUaFit6JeQWJi63hmktmuV0EdiuRg
+5H+sXmQYHwXZkvR0WD4p4W9J0koFqPE5/VcmN+OaAUnuewAwDjxGgXGwkKXd5kH
lh8XUoGzWu4L4rlMDWus
=yNYE
-----END PGP SIGNATURE-----

--=-AZpcvHBoX8O4KlSgYzhO--

