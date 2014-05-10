Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:57537 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbaEJR1k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2014 13:27:40 -0400
Date: Sat, 10 May 2014 19:27:26 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [RFC][PATCH] b43: drop SSB dependency
Message-ID: <20140510192726.5e0301df@wiggum> (sfid-20140510_192743_270519_783AEFD6)
In-Reply-To: <CACna6rzS8_VCtJhktiX1B+MoM714_j_LRzHK0SzcGNnr1JzBNg@mail.gmail.com>
References: <1399733088-26607-1-git-send-email-zajec5@gmail.com>
	<20140510171721.54b21a63@wiggum>
	<CACna6rwdXiGwLW=vuo2MMaQHYAWjDwc_W2zufmVbkmpBsMMp-Q@mail.gmail.com>
	<20140510183645.04c801f2@wiggum>
	<CACna6rzS8_VCtJhktiX1B+MoM714_j_LRzHK0SzcGNnr1JzBNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/FXIW0LUpe.3gMUrPGPRGFQC"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/FXIW0LUpe.3gMUrPGPRGFQC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 10 May 2014 19:05:33 +0200
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> > I'm currently unsure.
> > You probably want to add select SSB to config B43_SSB and the same for =
B43_BCMA.
>=20
> I've just tried this, however this will force SSB to be "y" (even if
> B43 is "m"). We have to select BCMA/SSB from non-bool configs.

Hm, OK makes sense.

> This lead me to the idea of select-ing SSB and BCMA in "B43" depending
> on the B43_BCMA and B43_SSB. That should make the trick. I'll test it
> and submit V2.

Could work, if you drop the unnecessary B43 dependency in those options.


--=20
Michael.

----
Please use PGP/GPG encryption.
Key-ID: F532BE1D908D8B0E
--------

--Sig_/FXIW0LUpe.3gMUrPGPRGFQC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTbmGBAAoJEPUyvh2QjYsOLSQQAM2EFFH0InTc184JD4pcphyo
JMpufq1RaxV40RXPgfEJtdiNdqmdffIeohJXESiSn89EdgSH16OF7SAV6vST5Fc5
pkGBPkyr9Nml49g50y2eV+Q4kChsZHxaceTw69IURP7PQ09dMUzMuLdlUOKDJUnV
MPKp3UstiNXj0gWH6l0XPShzyyfqFQGzcsnueRgVnyMoBXqPFxCaHGAG/v5vydwm
jmOP0TVpELb2wBaRr1FUq0AdIKyn0E6ClQsHBxUKLI3CZOuBa8IEIuEvqVcMWCuD
d926oGTXukpLQZFg4htISi+u4TcDR6ParprB0iv7kXsZeZqZr6P/RONPh8O9XfLh
h7hcF1wSgaKmHzRR3+Yo0eDbsoKn5zpl41pWaltqgyhRaTxLCXN2HjW7UPzIOMrX
SahELRokyTyjtXFXAXEixZUIb0e8zpt1dNth2JbDht86DJnbKYJWySzXphzIwdAe
1s/SBOVQP+19QzFT2Yx50kchC4TBclCYWUJ3GHUUtU3klsPy1nH7fhoOBNNXEpGe
XbH9F9QJQnkO563CFg9b6CCHe1I4k8de5FFIcdnCfHeI+gwt3CF0SVDG9UB4F6o0
yf+k95JjSY07eTZooqk9jRl9frvzgi65dR6K2Q4A3lysmWEKq2DvuAX/OhJZJkzS
wt3HIdhEvl7gQqAwhkbu
=U56N
-----END PGP SIGNATURE-----

--Sig_/FXIW0LUpe.3gMUrPGPRGFQC--
