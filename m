Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42540 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030305AbXCCPTA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2007 10:19:00 -0500
Subject: Re: [patch] at76_usb wireless driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Guido Guenther <agx@sigxcpu.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1172934588.4966.46.camel@johannes.berg>
References: <20070110145724.GA4171@bogon.ms20.nix>
	 <20070223221230.GA9965@bogon.ms20.nix>
	 <20070303150029.GA19940@bogon.ms20.nix>
	 <1172934588.4966.46.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RCZwXwnnhjpP5AwKBcGb"
Date: Sat, 03 Mar 2007 16:18:36 +0100
Message-Id: <1172935117.4966.54.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RCZwXwnnhjpP5AwKBcGb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Quick comments on this driver.

 (1) I'd prefer if the huge list of USB IDs was in a header file that is
     included, quick cut'n'paste job :)
 (2) remove the LED stuff for ipaq, that belongs into an LED trigger and
     ipaq can define an LED driver for the LED so you can hook it up,
     also makes it generic so other people can use the LED trigger
     functionality
 (3) don't initialise static variables to 0
 (4) reorder code so less function prototypes are required

more to follow after tea.

johannes

--=-RCZwXwnnhjpP5AwKBcGb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF6ZHM/ETPhpq3jKURAkAWAKC13a4YPnd2rs3GXTzQsbEkLWH7EQCdFlwU
+Vw5Myqfnor/Zbp8cLDvRLo=
=NiLg
-----END PGP SIGNATURE-----

--=-RCZwXwnnhjpP5AwKBcGb--

