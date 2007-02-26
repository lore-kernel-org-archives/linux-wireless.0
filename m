Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40817 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030276AbXBZOYq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Feb 2007 09:24:46 -0500
Received: from [84.135.211.92] (helo=johannes.berg)
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.63)
	(envelope-from <johannes@sipsolutions.net>)
	id 1HLgiL-0005eP-5b
	for linux-wireless@vger.kernel.org; Mon, 26 Feb 2007 14:20:29 +0000
Subject: FYI: linuxwireless.org device database
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5uimpI2IzAcBCSSiW/32"
Date: Mon, 26 Feb 2007 15:24:27 +0100
Message-Id: <1172499867.3870.160.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5uimpI2IzAcBCSSiW/32
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Over the past couple of days I've been working on adding a device
database to linuxwireless.org. The "database" is completely within the
wiki itself and initially per-driver at e.g.
http://linuxwireless.org/en/users/Drivers/bcm43xx/devices

The en/users/Drivers/*/devices tables are then pulled together into
http://linuxwireless.org/en/users/Devices/PCI and
http://linuxwireless.org/en/users/Devices/USB

For drivers that support both USB and PCI devices (and possibly PCMCIA
in the future) we'll have to figure out if we want to split lists or
such.

In any case, I've migrated information on bcm43xx and zd1211rw, I'd
appreciate if other driver writers could start filling tables as well.
The fields shown on the common device list should be filled in, but as
you can see with both zd1211rw and bcm43xx drivers additional fields may
be present and some fields can be set to be identical for all rows.

johannes

--=-5uimpI2IzAcBCSSiW/32
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF4u2b/ETPhpq3jKURAmPzAJ9pqqceAwmcXxE9ooa2tIVy7ZmhXwCeNyQ2
Eb6OIHrAmzIa4bNU2OnRNSY=
=MK4h
-----END PGP SIGNATURE-----

--=-5uimpI2IzAcBCSSiW/32--

