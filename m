Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46387 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbXJHJ4L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2007 05:56:11 -0400
Subject: Re: [PATCH] libertas: fix "warning: Using plain integer as NULL
	pointer" sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200710081148.00041.hs4233@mail.mn-solutions.de> (sfid-20071008_104759_880773_6B6B7D7A)
References: <200710081141.23237.hs4233@mail.mn-solutions.de>
	 <200710081148.00041.hs4233@mail.mn-solutions.de>
	 (sfid-20071008_104759_880773_6B6B7D7A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Yg27weEgcfOIBym+unKh"
Date: Mon, 08 Oct 2007 11:56:38 +0200
Message-Id: <1191837398.4063.27.camel@johannes.berg> (sfid-20071008_105615_281806_6856D707)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Yg27weEgcfOIBym+unKh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-10-08 at 11:47 +0200, Holger Schurig wrote:

> checkpatch.pl barks on this patch anyway, because of the
> ridiculus 80 columns restriction it wants to impose. Should I=20
> rephrase the patch because of this or just ignore this=20
> checkpatch warning?

Personally, I'd prefer it written as "extended booleans" anyway:

+       if (!pscancfgout || !pchantlvout || !pscanchanlist)

johannes

--=-Yg27weEgcfOIBym+unKh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwn+1aVg1VMiehFYAQI1mw//bjT6XIeUN353TO2Yua/mbm+AkqZEEjea
SdoT3E2n9mS6uPAg1e6YxcZvehcOHfBvs4+pFIY5uuHcykdv4lXdtKu41SpzLn7S
jptGTVmalawiQhtKMpC0HGdrTCuC6/h/hKouK6wMcBqWwnCZgROMXpqQ3ChVWTL8
4Km1jt64M6y3y4o5a+TI9aq0FAI5mMk1gQFNgoZ8jorw8M9zNt+rNORq1ZyPOZz7
abS0hjXgWlVb97RdDPL+QolpGAg1fvXOVf4P0HXu9tAUamnDDBF8FQ4siuR+aBlO
nJLHfhN7DD3QXEriAR/vKtkIxl77w6pkK4WIsp0Y0refy8XZLZmXFUTJ/MgQpl/9
vZie+abQRNSJGWXWzAawCziBG0TEuLXBnB1orGDJTtQWPNysgw6fJuiG/PL0sEMI
He1VHEjAqVr0gFeOV62pp5kegydtkTQTNBzkltKkMtT4pY5ZPrK5lxEcMvatfvaW
JaNTpgIF9AGviNxUp7daR3zZhKzKQghBC57RlMGCcrii68IV3dXzjKxITlAS3658
T5anxVYiYKhQK9+Vw0cOyUR4NiHk0/zZUD20/sVoplIbqI5GZCaRGav0u+UGBLDA
b+mrATDr9k3c2H2rmc9bn0SLj/YHYhtsVzUjt/Li0RtXCK9I1ooktpdhxWzskikk
iEvdyBsfg8k=
=tkmP
-----END PGP SIGNATURE-----

--=-Yg27weEgcfOIBym+unKh--

