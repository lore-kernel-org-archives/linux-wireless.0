Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52422 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759509Ab3GSAqS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jul 2013 20:46:18 -0400
Message-ID: <1374194768.15633.32.camel@deadeye.wl.decadent.org.uk> (sfid-20130719_024622_659297_296CEEB6)
Subject: Re: [PATCH] reglib: Validate all structure and array lengths
From: Ben Hutchings <ben@decadent.org.uk>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>, alexandre <alexandre@cmu.edu>
Date: Fri, 19 Jul 2013 01:46:08 +0100
In-Reply-To: <CAB=NE6Vz_3d9Vz62dNTWocT3MTqvG4Ez+MZc0w-w8KBgkaapxg@mail.gmail.com>
References: <1372636171.5155.56.camel@deadeye.wl.decadent.org.uk>
	 <CAB=NE6Vz_3d9Vz62dNTWocT3MTqvG4Ez+MZc0w-w8KBgkaapxg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-VWOJSSIPUGV2ekG1vyZg"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VWOJSSIPUGV2ekG1vyZg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-07-16 at 18:31 -0700, Luis R. Rodriguez wrote:
> On Sun, Jun 30, 2013 at 4:49 PM, Ben Hutchings <ben@decadent.org.uk> wrot=
e:
> > Add checks that:
> > - Signature length does not exceed the file length (this was already
> >   checked, but did not account for signature lengths greater than 2 GB)
> > - Database length is long enough for all structures we expect in it
> > - Array length calculations will not overflow
> >
> > To keep these checks simple, change the types of array length and index
> > variables to unsigned int (must be at least 32-bit, matching the file
> > format) and the types of byte-length variables to size_t.
> >
> > Alexandre Rebert <alexandre@cmu.edu> reported and provided a test case
> > for the signature length issue; the others I found by inspection.
> >
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
>=20
> Thanks! Despite the fact you didn't resend for a wider review and I
> would have preferred this split up into a few patches this has been
> sitting on wireless-regdb for a while, so after my review I just
> applied and pushed. Thanks again!

Sorry about that - I was meaning to re-send but it never quite got to
the top of my to-do list.

Ben.

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

--=-VWOJSSIPUGV2ekG1vyZg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUeiMUOe/yOyVhhEJAQoeQBAAqHb8o28Uiz/SjyG59he2b/xJjLsQd7oc
6PglNUY7qsJ5m0fZTmdWctwdKexPJOF4YCQrInPXr/jKoJ0sJVCUeWUoT7Nft+Mm
xA1D0Ruxc9DbIZzEDysJ6V1P9AIlJVIeUCt9y4I4fzj1vx/MYBfdg5DdXZ00g8NY
UqzPXAtgMDr1k1D2od3xYeXqs97oxKLZhky08Y6sVKTCdmDrVVt6BIjYpoMtrfTo
1H+9Hjo5PIkusXbm0iYsoRvAd1p4GS4R0eSHW981SWTQtOa4579KV9jla+G1cVHa
nvwyM53z+/H55+NT9TVVbINKy2lR06xn/uadPUX/qcQ1v1MpwBNxQ66bhGtZSjer
UK375FKF23s1kf/2GbhKQ+IaNhbeei6VErcEHUt7rFMl7Ia+fEJgaGOja9pL5yuX
3Myd3zsqmdehIqEjGrZmupjNo5tmQxMnAeGx4YZeJqNkiB6qupKpnDSmkzz5/lqY
UXuID4fxea9iGBAbZlwUy+TM2oxvDwzRNpHj5ci28u2Q3MX7ZfZpaEYmgkxSVmJB
qSDxX9GH3BU4RsMg6cO1/4U5WkV8vduJyT5iicKgF4xmtxZU23lkoN2eBSE23s61
Kb3xWHwJsbGdBlDU/Fc1gGBhnDxG9DKwiVBqqBxj3mXzJdc1osjlQmTPQBM3cBcm
i7zzUptdZLM=
=wVOA
-----END PGP SIGNATURE-----

--=-VWOJSSIPUGV2ekG1vyZg--
