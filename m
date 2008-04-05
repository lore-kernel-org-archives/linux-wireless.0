Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43135 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbYDEA0M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 20:26:12 -0400
Subject: Re: [PATCH 5/5] p54: update Makefile and Kconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: Chr <chunkeey@web.de>
Cc: mcgrof@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net
In-Reply-To: <200804050219.32270.chunkeey@web.de>
References: <E1Jhv2j-0006LQ-3j@debian64.daheim>
	 <1207351939.6675.2.camel@johannes.berg>
	 <200804050219.32270.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BbSsLmXDkT5BKHp3l4gH"
Date: Sat, 05 Apr 2008 02:26:07 +0200
Message-Id: <1207355167.6675.9.camel@johannes.berg> (sfid-20080405_012616_221210_0875861C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BbSsLmXDkT5BKHp3l4gH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> John? can you please do the git mv?
> I have attached a diff to make checkpatch.pl happy, so you don't have to =
do=20
> it. ;-)

Uh, I think you need at least a small patch that modifies the
drivers/net/wireless/{Makefile,Kconfig} as appropriate. From what I
could see, your original patch didn't even add the wireless/p54/Kconfig
into wireless/Kconfig so it wouldn't be useful?

johannes

--=-BbSsLmXDkT5BKHp3l4gH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/bHHqVg1VMiehFYAQLSmRAAnuQHpTfUmkFqp5HNhSqytNrjzTOWGuuc
GXzpU/oLEjxGHlvcNWOvYgLpvi7oSDdVbEDXjW7GtoDokj8ggLnbcZOSUAuK1tY2
pMi8YdldbmNEPwp/sQ6GMkTzRbWBuBeuY3LtLoVdjpS63aELu767Glpg6wqJIKOB
G1VyxIdcoKWb4dbrreZegYKVWLfWBAlYeg6w1SMElS/3JQFFVQcg1K5OReUpAOCF
XWF/WBoH2jW/gitJ0FcYo4I77U6CTJ8MmfqRyWEGBTOmscNJZkCUHbcOrZ+p41xg
cY2QlQtU5ny0KyRqXbA1BDDngwNn2KcvSokav7U8AeJdVD4h2F/7QZRgz024JnFR
arwi/45tF5P0hokHiY63+O5b0Rs2yUMmBeYGyFX0dYu8XNzNi+2xAXc8ptK3Fqa3
hjpkEfhcmcvd6QNgQm6i0qQ8ynjSuQXx49DHq8U2EnNPilD+JdOyPDFH4gmLegJ1
qD3nEeLaEwtmAcVNCpI/5WWjG53MY830q0tQfS8BmE65vh00pCgEp4hIwbUwDhIV
swxVZl5PM6asPcaC7L9fzQoiwPwT9Km3pJLaprVwQVQnCgwtnShj1E6f6E+hQK1C
sVVyH+yH8T6dql6jb1ytvq5cvXtstnWES76Iy8gF/gnniF92ZiUbVQUCPLLBylxe
KtYjej/+Omw=
=2Xa+
-----END PGP SIGNATURE-----

--=-BbSsLmXDkT5BKHp3l4gH--

