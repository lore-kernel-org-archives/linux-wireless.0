Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:58954
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755465AbZKBVL3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 16:11:29 -0500
Date: Mon, 2 Nov 2009 13:11:23 -0800
From: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Frank Schaefer <schaefer.frank@gmx.net>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N devices in cdrom mode
Message-ID: <20091102211123.GI24436@one-eyed-alien.net>
References: <200910171606.02961.oliver@neukum.org> <Pine.LNX.4.44L0.0910171130550.25594-100000@netrider.rowland.org> <20091017220313.GH24502@one-eyed-alien.net> <4ADC3657.6080906@gmx.net> <4AEDCCA0.8050709@gmx.net> <4AEDD380.40408@draisberghof.de> <4AEDEB85.5080105@gmx.net> <20091102005144.GE24436@one-eyed-alien.net> <4AEF3CAD.10809@gmx.net> <1257193115.1027.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gTY1JhLGodeuSBqf"
In-Reply-To: <1257193115.1027.24.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--gTY1JhLGodeuSBqf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 02, 2009 at 12:18:35PM -0800, Dan Williams wrote:
> Devices with fake driver CDs and how they are handled currently:
>=20
> Zydas WLAN   - kernel
> Huawei 3G    - kernel  (unusual_devs entry)
> Sierra 3G    - kernel  (drivers/usb/serial/sierra.c)
> Option 3G    - udev rules, 'rezero', or usb_modeswitch
> ZTE 3G       - udev rules, simple 'eject'

It's worth noting that for some of these which are handled in-kernel, it
had to be done that way because their storage-emulation was so poor that
the normal 'eject' WOULD NOT work properly.

Any device which can be handled in userspace SHOULD be handled there.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

But where are the THEMES?!  How do you expect me to use an OS without=20
themes?!
					-- Stef
User Friendly, 10/9/1998

--gTY1JhLGodeuSBqf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFK70r7HL9iwnUZqnkRAkP+AJ95takg/AUNwLej/Per/JORgu9plgCePxWp
iMujnaBqDJvRYuZ/dhwij4o=
=F9NV
-----END PGP SIGNATURE-----

--gTY1JhLGodeuSBqf--
