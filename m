Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:59460
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751059AbZKATfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Nov 2009 14:35:52 -0500
Date: Sun, 1 Nov 2009 10:35:53 -0800
From: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
To: Josua Dietze <digidietze@draisberghof.de>
Cc: Frank Schaefer <schaefer.frank@gmx.net>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
	johannes@sipsolutions.net, chunkeey@web.de
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N devices in cdrom mode
Message-ID: <20091101183553.GB24436@one-eyed-alien.net>
References: <200910171606.02961.oliver@neukum.org> <Pine.LNX.4.44L0.0910171130550.25594-100000@netrider.rowland.org> <20091017220313.GH24502@one-eyed-alien.net> <4ADC3657.6080906@gmx.net> <4AEDCCA0.8050709@gmx.net> <4AEDD380.40408@draisberghof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pvezYHf7grwyp3Bc"
In-Reply-To: <4AEDD380.40408@draisberghof.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 01, 2009 at 07:29:20PM +0100, Josua Dietze wrote:
> Frank Schaefer schrieb:
>=20
> >I really think the mode-switching should be done in the kernel and not
> >in user-space for reasons of usability.
>=20
> What is wrong with an udev rule entry? By the way, did the "eject"=20
> command line tool work as well?

And I think it should be done in userspace for issues of maintainability
and useability.  It is much easier for users to upgrade their udev then
their kernel.

> >Another benfit is that it binds the mode-switching to the driver. If the
> >driver is blacklisted/not used, there will be no mode-switching.
>=20
>=20
> But how would you access the storage part of the device then?

And doing the switch in userspace would solve this problem also.

Finally, if we do this in userspace, device vendors might actually get a
clue and start providing a small linux app or script to do the mode switch
on their virtual storage device, just like they do for windows.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

C:  They kicked your ass, didn't they?
S:  They were cheating!
					-- The Chief and Stef
User Friendly, 11/19/1997

--pvezYHf7grwyp3Bc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFK7dUJHL9iwnUZqnkRAp1kAJkBGA4WOg8miDPl1ohsT4rGOgCqaACcCRM1
hrhTpozBhLDUlhsCfEcYHxU=
=9SS5
-----END PGP SIGNATURE-----

--pvezYHf7grwyp3Bc--
