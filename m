Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:45402
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935356AbZLQSWT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2009 13:22:19 -0500
Date: Thu, 17 Dec 2009 10:21:34 -0800
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Oliver Neukum <oliver@neukum.org>
Cc: Dan Williams <dcbw@redhat.com>,
	Josua Dietze <digidietze@draisberghof.de>,
	Stefan Seyfried <stefan.seyfried@googlemail.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
	Stefan Seyfried <seife@sphairon.com>
Subject: Re: [PATCH] move eject code from zd1211rw to usb-storage
Message-ID: <20091217182134.GL16426@one-eyed-alien.net>
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com> <1260993048.2179.68.camel@localhost.localdomain> <20091216195258.GJ16426@one-eyed-alien.net> <200912171402.42168.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k9xkV0rc9XGsukaG"
In-Reply-To: <200912171402.42168.oliver@neukum.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--k9xkV0rc9XGsukaG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 17, 2009 at 02:02:41PM +0100, Oliver Neukum wrote:
> Am Mittwoch, 16. Dezember 2009 20:52:58 schrieb Matthew Dharm:
> > > > If this is the case, then the only reasonable answer to is to push =
the
> > > > modeswitch code for both into udev and out of the kernel.  It will =
take
> > >=20
> > > you mean usb_modeswitch, not udev actually.
> >=20
> > That is correct; I had mis-typed.  Tho, the actual implementation is ud=
ev
> > calling usb_modeswitch and/or eject.
>=20
> Can storage tell the devices apart so that it knows which ones to leave
> to the kernel solution and which devices to accept so that udev can
> issue an eject command?

Maybe.  Depends on how identical the devices are.  We would need to compare
descriptors between the two devices.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

E:  You run this ship with Windows?!  YOU IDIOT!
L:  Give me a break, it came bundled with the computer!
					-- ESR and Lan Solaris
User Friendly, 12/8/1998

--k9xkV0rc9XGsukaG
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFLKnauHL9iwnUZqnkRAmH3AKCWHehrHnKs8etIDdM/Zahw4N4/+wCeMc9v
Ax62Eh9o71uSWUOE1ZkIUfo=
=GOim
-----END PGP SIGNATURE-----

--k9xkV0rc9XGsukaG--
