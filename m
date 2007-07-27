Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42294 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759370AbXG0JzL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 05:55:11 -0400
Subject: Re: A problem with shared interrupts
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de
In-Reply-To: <46a90082./TQABjOfVYW1o6lY%Larry.Finger@lwfinger.net>
References: <46a90082./TQABjOfVYW1o6lY%Larry.Finger@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dmxcesdSnIKN6NPftAHb"
Date: Fri, 27 Jul 2007 11:54:30 +0200
Message-Id: <1185530070.4006.46.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dmxcesdSnIKN6NPftAHb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-07-26 at 15:13 -0500, Larry Finger wrote:
> Michael,
>=20
> When I try the -mb tree on my old i386 notebook, I get an "irq 11: nobody=
 cared"
> message and interrupts for the bcm43xx-mac80211 device are not initialize=
d.

Hm. Just a thought about something related: do you have 'debug shared
interrupts' on?

johannes

--=-dmxcesdSnIKN6NPftAHb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGqcDW/ETPhpq3jKURAokSAKC2pZPELCeuC8IdLVU4mBU/jSqOhwCcDKLy
LrIlVerL5w5JLuBmbronIPs=
=uWfX
-----END PGP SIGNATURE-----

--=-dmxcesdSnIKN6NPftAHb--

