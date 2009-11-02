Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:59432
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753442AbZKBAwN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Nov 2009 19:52:13 -0500
Date: Sun, 1 Nov 2009 16:51:44 -0800
From: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
To: Frank Schaefer <schaefer.frank@gmx.net>
Cc: Josua Dietze <digidietze@draisberghof.de>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N devices in cdrom mode
Message-ID: <20091102005144.GE24436@one-eyed-alien.net>
References: <200910171606.02961.oliver@neukum.org> <Pine.LNX.4.44L0.0910171130550.25594-100000@netrider.rowland.org> <20091017220313.GH24502@one-eyed-alien.net> <4ADC3657.6080906@gmx.net> <4AEDCCA0.8050709@gmx.net> <4AEDD380.40408@draisberghof.de> <4AEDEB85.5080105@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wchHw8dVAp53YPj8"
In-Reply-To: <4AEDEB85.5080105@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--wchHw8dVAp53YPj8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 01, 2009 at 09:11:49PM +0100, Frank Schaefer wrote:
> Josua Dietze schrieb:
> > Frank Schaefer schrieb:
> >
> >> I really think the mode-switching should be done in the kernel and not
> >> in user-space for reasons of usability.
> >
> > What is wrong with an udev rule entry? By the way, did the "eject"
> > command line tool work as well?
> It returns an error but the device is ejected.
> But do you really want the users to open a terminal window and call
> "eject" each time they plug their device in ;) ?

If 'eject' worked, then why not use a simple udev entry?  That way nobody
has to call anything by hand...

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Why am I talking to a toilet brush?
					-- CEO
User Friendly, 4/30/1998

--wchHw8dVAp53YPj8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFK7i0gHL9iwnUZqnkRAtEVAJ47279GFmUz0zRTGpiBQis4lW5sTQCdH7+F
C5mOVgxe1buDU3pX6D+gxpY=
=f2uK
-----END PGP SIGNATURE-----

--wchHw8dVAp53YPj8--
