Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:34880
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754857AbZKBVP0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 16:15:26 -0500
Date: Mon, 2 Nov 2009 13:15:28 -0800
From: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
To: Frank Schaefer <schaefer.frank@gmx.net>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N devices in cdrom mode
Message-ID: <20091102211528.GJ24436@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0910171130550.25594-100000@netrider.rowland.org> <20091017220313.GH24502@one-eyed-alien.net> <4ADC3657.6080906@gmx.net> <4AEDCCA0.8050709@gmx.net> <4AEDD380.40408@draisberghof.de> <20091101183553.GB24436@one-eyed-alien.net> <4AEDEE7C.4010406@gmx.net> <20091102004756.GC24436@one-eyed-alien.net> <4AEF3BF8.1080701@gmx.net> <20091102211001.GH24436@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6J7GEvtanOfV9oXA"
In-Reply-To: <20091102211001.GH24436@one-eyed-alien.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--6J7GEvtanOfV9oXA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 02, 2009 at 01:10:01PM -0800, Matthew Dharm wrote:
> I think you may have missed part of an earlier discussion, wherein we
> discussed such devices which would NOT need ANY kernel changes.  The idea
> was that udev could "eject" the fake-USB device, then add the device IDs =
to
> the serial/cdc_amc/whatever driver dynamically, at runtime.  Thus, no need
> to make any kernel updates at all.
>=20
> And, that system works *today* with the existing kernel code.

Search the archives for "Toshiba G450" if you want to find that discussion.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Sir, for the hundreth time, we do NOT carry 600-round boxes of belt-fed=20
suction darts!
					-- Salesperson to Greg
User Friendly, 12/30/1997

--6J7GEvtanOfV9oXA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFK70vwHL9iwnUZqnkRAgI0AJ9ZNE1kz/A9aonxLflTh2jlUoUolgCePUO3
CpgwdXrwc5EeAeZ/WwK8mvc=
=Cw7Q
-----END PGP SIGNATURE-----

--6J7GEvtanOfV9oXA--
