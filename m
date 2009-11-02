Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:38494
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627AbZKBAr5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Nov 2009 19:47:57 -0500
Date: Sun, 1 Nov 2009 16:47:56 -0800
From: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
To: Frank Schaefer <schaefer.frank@gmx.net>
Cc: linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N devices in cdrom mode
Message-ID: <20091102004756.GC24436@one-eyed-alien.net>
References: <200910171606.02961.oliver@neukum.org> <Pine.LNX.4.44L0.0910171130550.25594-100000@netrider.rowland.org> <20091017220313.GH24502@one-eyed-alien.net> <4ADC3657.6080906@gmx.net> <4AEDCCA0.8050709@gmx.net> <4AEDD380.40408@draisberghof.de> <20091101183553.GB24436@one-eyed-alien.net> <4AEDEE7C.4010406@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hOcCNbCCxyk/YU74"
In-Reply-To: <4AEDEE7C.4010406@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--hOcCNbCCxyk/YU74
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 01, 2009 at 09:24:28PM +0100, Frank Schaefer wrote:
> Matthew Dharm schrieb:
> > On Sun, Nov 01, 2009 at 07:29:20PM +0100, Josua Dietze wrote:
> >  =20
> >> Frank Schaefer schrieb:
> >>
> >>    =20
> >>> I really think the mode-switching should be done in the kernel and not
> >>> in user-space for reasons of usability.
> >>>      =20
> >> What is wrong with an udev rule entry? By the way, did the "eject"=20
> >> command line tool work as well?
> >>    =20
> >
> > And I think it should be done in userspace for issues of maintainability
> > and useability.  It is much easier for users to upgrade their udev then
> > their kernel.
> >  =20
> Maintainability for whom ? The kernel-devs or the distro-people and the
> users ? ;)

Both.

> Please think about the users. They don't know that they have to create
> udev-rules or have to install additional packages like usb_modeswitch
> (which is nevertheless a great tool !).
> And even if they know, they don't want to do that. So it's up to the
> distros to do this automatically, which will in reality never come true
> for all devices and distros.

I am thinking about the users.  Do you really think someone who has
difficulty installing a new udev rule (probably a line or two of text
copied from a google search) or installing a new version of usb_modeswitch
(probably one or two commands to the distro package manager) will have an
easier time doing a custom kernel-compile and update?

Updates in userspace are universally easier; on users, on kernel deves, and
on distro devs.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Hey Chief.  We've figured out how to save the technical department.  We=20
need to be committed.
					-- The Techs
User Friendly, 1/22/1998

--hOcCNbCCxyk/YU74
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFK7iw8HL9iwnUZqnkRAkBxAJ9g+wxVrwy+SvX5XBc+eP7jQe3N0ACfasIV
UCwiQ2LRRbBOBAB4ONlJHHQ=
=DXrL
-----END PGP SIGNATURE-----

--hOcCNbCCxyk/YU74--
