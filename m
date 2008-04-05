Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59728 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbYDEBIZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 21:08:25 -0400
Subject: Re: [PATCH 5/5] p54: update Makefile and Kconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: Chr <chunkeey@web.de>
Cc: mcgrof@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net
In-Reply-To: <200804050242.36018.chunkeey@web.de>
References: <E1Jhv2j-0006LQ-3j@debian64.daheim>
	 <200804050219.32270.chunkeey@web.de>
	 <1207355167.6675.9.camel@johannes.berg>
	 <200804050242.36018.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hZktyRvxAcgT4XFUtlib"
Date: Sat, 05 Apr 2008 03:07:38 +0200
Message-Id: <1207357659.3860.0.camel@johannes.berg> (sfid-20080405_020838_236006_6B68AE3A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hZktyRvxAcgT4XFUtlib
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sat, 2008-04-05 at 02:42 +0200, Chr wrote:
> On Saturday 05 April 2008 02:26:07 Johannes Berg wrote:
> > > John? can you please do the git mv?
> > > I have attached a diff to make checkpatch.pl happy, so you don't have=
 to
> > > do it. ;-)
> >
> > Uh, I think you need at least a small patch that modifies the
> > drivers/net/wireless/{Makefile,Kconfig} as appropriate. From what I
> > could see, your original patch didn't even add the wireless/p54/Kconfig
> > into wireless/Kconfig so it wouldn't be useful?
> >
>=20
> hmmmmm, look careful! one small + ;-) it's nearly invisible.
>=20
> +source "drivers/net/wireless/p54/Kconfig"=20

Ah, so we need this patch (5/5) and the git mv. Sorry, got confused
because you sent some other patch :)

johannes

--=-hZktyRvxAcgT4XFUtlib
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/bQ2aVg1VMiehFYAQLhaw//RG7Vp/P/vapVs4KD+cJuLVb1N1uhGxmh
qJv5juVb9cZKe1PhiIhSqKT+Ze7oOhWzFmlDTJl5UtxwCkM2o+ZnH8bm8enCJl0N
zvRoZ3aZcPziAnXGJRAh/SE2I7yZ0wiwOq3E6ZiuKQHUvoSfywU57sZUCT7WtvrX
6b/KRUNQcmm4ZvqWCCzo78DRSFudhMav3ZiqDJ5YqqKcUb/NQDODTDBNhjuv71as
uNduWrnHFECUdptti/D8DbHPKKAY0lcbx18KoqrEypIuZStcJ123ITz+wn8id54c
gq+ZybNqcRkboCOT5sysxhtj3+wxKg+g3VaOiFuoWf4kYa/P0xMrd/I9L1xN0v0o
n/rqu2LxM5hvxy5TY5P5i7rgpTHB72VVEIGY4xpsLRcMhBceo9Oj7vd8g7W1Kmq6
i6PFmk9W54pOedWzjlF03XEPG/RaoCs2ji3yXMP99Fr2KLO75oeFH4eMwBIrEryH
FtmxfQkDuG/7wQ5s2+3uydwbr+KWykvYiQPTTIyKy2xQkneYL4yuKjMwz4X4ItL9
1tn035CO4jwakqbj1hOeNyBykHRFTFbnUlQHKFQ9HR2+wavORfhHcRaPd7PdegzB
e3LUweG9Z5wv9BvYcxKKLaPSNEipET9Id1u06lS+tSZZAwqgs9D7WKJpUYPzBKkf
6Yf2wM1xJJc=
=MkZ7
-----END PGP SIGNATURE-----

--=-hZktyRvxAcgT4XFUtlib--

