Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51181 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbYGASpj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 14:45:39 -0400
Subject: Re: [PATCH/RFC] b43: remove input device usage for rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Michael Buesch <mb@bu3sch.de>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
	Larry Finger <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <20080701184124.GE24605@khazad-dum.debian.net>
References: <6cf6b73e0807010255x1f2d8a21m8ed3e712012ea757@mail.gmail.com>
	 <200807011227.15805.mb@bu3sch.de>
	 <20080701143439.GA6962@khazad-dum.debian.net>
	 <1214923097.3462.0.camel@johannes.berg>
	 <20080701165036.GB6962@khazad-dum.debian.net>
	 <1214931676.3462.5.camel@johannes.berg>
	 <20080701173345.GA24605@khazad-dum.debian.net>
	 <1214935291.3462.7.camel@johannes.berg>
	 <20080701184124.GE24605@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dPdmj16NQi5Y/MFKtLb4"
Date: Tue, 01 Jul 2008 20:44:36 +0200
Message-Id: <1214937876.3462.10.camel@johannes.berg> (sfid-20080701_204543_551389_4BE8B31E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dPdmj16NQi5Y/MFKtLb4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-01 at 15:41 -0300, Henrique de Moraes Holschuh wrote:
> On Tue, 01 Jul 2008, Johannes Berg wrote:
> > > THIS is very interesting alright...  and it is *extremely* important,=
 so
> > > let's triple verify it, shall we?
> > >=20
> > > Please hack the driver to try to transmit data with that bit set to h=
igh, and
> > > also with that bit set to low.  The best way to go about it is probab=
ly to
> > > disable the rfkill support (so that it doesn't get in the way), hack =
the
> > > check-the-bit function to just printk its state, and see if the radio=
 can
> > > effectively transmit and communicate no matter what state the input p=
in is
> > > at.
> > >=20
> > > This is very important.  It will caracterize that input pin as either=
 an
> > > hardware rfkill line, or as an input device (in which case I would be=
 wrong
> > > when I asked to remove the input support from b43, but one step at a =
time).
> >=20
> > Sorry, no, I think I got confused, it should be a hardware rfkill line.
>=20
> I'd like to have a certain response for this.  Can you test, and assert
> whether it is a rfkill line or not?
>=20
> And, if it IS a rfkill line, I still need to know if it is flip-flop-like=
 or
> not...  I am not certain I got the right idea (I understood it was NOT
> flip-flop-like).

No, it's not flip-flop, there's definitely an on/off bit that always
matches the button/hardware state.

johannes

--=-dPdmj16NQi5Y/MFKtLb4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIansQAAoJEKVg1VMiehFYiBkQAJVIMU5YcQNXzPIEgyRiaZRR
IreBE9wi7pGI143uZC+UHDDNHCbJ/QDzQLsyLnAN6WlXIKixUnjzg3EPtt28lHZc
xYr7YWnEqQ2mb4wTO+oUqFnwO5iscqtUXkR6m2nPg9iSEryDXrJ/pWkKgj16Z0Ih
ouZssj2mzchTyRw62KII5yAaP1HUHLKloE1lD3m82UjO6EB0R8A3EqOycMPhz8kj
FQKNB7ASOCQre+vd8Bflg/i/A5iixE6h0QcbxDuY1B2AT9D6eXROvFedmmLqMvtG
neiLZAv6wp5uW7BSQIBZt6XxRjIKXtZ5fYUA2VzZIdD1deg7HDCaiRGNmqup8zUL
c0JS0E87SE77dFFJ7Yz4jDBsCVUXASdA5l02hOkxyp/tTJPb29H3cRqCUT15NhBk
7kG2OkyZ8CErBi2giIsB3TE5f7Ax4U+NrFLq7m2Fr0RL2u2GGifTjGSsDOTIWwxR
6E/qRISrIyGKpDyNo4L40Lr2TaqFjaXCvXJqFqFCLcRj59tqZ4rJgyvvLojXPpEi
eU6hxZW63uVXfBG7NkxPVQxQdgqp+v6qf9VemIRbOI0vAq2Qi/FwRp+z0Iq4tkDK
3M/bj3w6g5/kl2wWa+xTvqxdSfx12afuu9NSyx4SyQzwCyFSDm5VzbG4w8jxPXbM
K+n94wrNFZCWYb1v6UqF
=ZBLz
-----END PGP SIGNATURE-----

--=-dPdmj16NQi5Y/MFKtLb4--

