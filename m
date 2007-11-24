Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48168 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbXKXVdb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 16:33:31 -0500
Subject: Re: wireless vs. alignment requirements
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, dsd@gentoo.org,
	davem@davemloft.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <4748855C.5090103@linux-foundation.org> (sfid-20071124_201316_613257_4C997365)
References: <E1IvoID-0006aR-00@gondolin.me.apana.org.au>
	 <1195893216.4149.186.camel@johannes.berg>
	 <20071124133200.GA27531@gondor.apana.org.au>
	 <1195912176.4149.194.camel@johannes.berg>
	 <20071124141319.GA27819@gondor.apana.org.au>
	 <4748855C.5090103@linux-foundation.org>
	 (sfid-20071124_201316_613257_4C997365)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AR9UCfDvReNfUU0AFp3v"
Date: Sat, 24 Nov 2007 22:33:14 +0100
Message-Id: <1195939994.4149.199.camel@johannes.berg> (sfid-20071124_213343_299461_EDFF3C43)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AR9UCfDvReNfUU0AFp3v
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Then what about hardware that can't dma ethernet to non-aligned address.
> Sky2 hardware breaks if DMA is not 8 byte aligned.  IMHO the IP stack sho=
uld
> handle any alignment, and do the appropriate memove if the CPU requires=20
> alignment.

Wouldn't that better be handled in the driver rather than having the
test in the generic RX path?

johannes

--=-AR9UCfDvReNfUU0AFp3v
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0iYmaVg1VMiehFYAQJcbw//WX3ty8Ui8C372ud1MKr5tCkkoDrEenNE
3wdO+/i7ZHEFwTc0p2TZiVcjmWk9xR1X01LMIo+2q5kILyK6R/lXUfAcS9G1TKpM
oyveI8Kx+PCs+9Jk1zu1GcmuaGcXSpX9bTCLL3OctscwnaGgvgLgV5tycn1tq7LO
ozjTpgUhZ/gjUqxqS4oYeX9clYqZZSjc05CIaN6mKuqXOGdFcSkSsfNr/t2H/Phf
JnYl+dzDy40Vtjdg1pdjsxkrtsBqoPwbjsUk60SLsc4+YNcLiXOqqKIaFbx/G17w
ARFerIYkNPyoiDDSLl3T0Lepp0ixQm9Rrzylvg5C2dYO3tiRMOOcZ0yJxWtRS3zk
MaEsUCEG3PkgswPRviUzZlkrZkVwfNOLzoTKFpYszkewJzDUgcmjLd/4EyrVC/3F
fHRKYXpEG4y6NZxU5Tde/bm5HPGKV1aKmPbFqUSnVwmVIY8CjiP2GFApoLsPGKZE
1FE7Fa/GUKuqU9JZyRfqHRvj7mpiHhXQbZB9RdtNGGHM6oWSt9dtizzAxlATa2OX
C7l5orRwz2rvyS2U5kOkS+s6XAewp8shHt12O91UffDr/FtKGuK229EfyPJ116B2
qQBf17Nbhqr5JjM1Qhb77U1QBvSEV0RArxTzctAri79IKrXi11zsJ8RKAp5uwSfL
OTnPsNpF2PY=
=8cJX
-----END PGP SIGNATURE-----

--=-AR9UCfDvReNfUU0AFp3v--

