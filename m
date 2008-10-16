Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx27.mail.ru ([194.67.23.23]:64502 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbYJPC46 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 22:56:58 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Dave <kilroyd@googlemail.com>
Subject: Re: pull request: wireless-2.6 2008-10-14
Date: Thu, 16 Oct 2008 06:56:48 +0400
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20081015013204.GH3349@tuxdriver.com> <48F6419B.80104@gmail.com>
In-Reply-To: <48F6419B.80104@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1334082.JPPloevjKT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200810160656.52910.arvidjaar@mail.ru> (sfid-20081016_045702_251873_96382EB3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1334082.JPPloevjKT
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 15 October 2008, Dave wrote:
> John W. Linville wrote:
> > Here is a nice little batch of wireless fixes in time for 2.6.28-rc1.
> > There are also a few USB ID additions as well.  I think this is all
> > mostly obvious, and hopefully still acceptable at this stage.
> >=20
> > Please let me know if there are problems!
>=20
> > Andrey Borzenkov (1):
> >       orinoco: fix unsafe locking in orinoco_cs_resume
>=20
> Hi John,
>=20
> Just wanted to check whether you'd seen/intend to apply the orinoco patch=
 Andrey posted in <http://marc.info/?l=3Dlinux-kernel&m=3D122365972026045&w=
=3D4>. It fixes a regression (vs 2.6.26) when using 4k stacks.
>=20

well ... this is not a regression actually as the bug is triggered by
new code that was added in 2.6.28. Still it is valid bug fix for new code
in 2.6.28 and IMHO quite appropriate. We better add it earlier so it
gets more testing.

Personally I think that two other patches should go in as well. They have
low regression potential (they apply to new code only; existing functionali=
ty
is not touched); and they make downloadable FW (and hence WPA) more
usable.

> Or whether you'd prefer that patch resent with an updated subject?
>=20

Me too?

--nextPart1334082.JPPloevjKT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkj2rXEACgkQR6LMutpd94yTrwCffZANYzqPlEiliXBSExX+Og1y
po0AoMeN+dTC9ubC6CZY30F3k9LuZDr2
=9C1z
-----END PGP SIGNATURE-----

--nextPart1334082.JPPloevjKT--
