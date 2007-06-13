Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52713 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbXFNJIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 05:08:14 -0400
Subject: rt2x00firmware.c missing some include
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4E5fjcA+51JoU5+6xm3B"
Date: Wed, 13 Jun 2007 23:41:11 +0200
Message-Id: <1181770871.29767.139.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4E5fjcA+51JoU5+6xm3B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I get

  CC [M]  drivers/net/wireless/mac80211/rt2x00/rt2x00firmware.o
drivers/net/wireless/mac80211/rt2x00/rt2x00firmware.c: In function =E2=80=
=98rt2x00lib_load_firmware_wait=E2=80=99:
drivers/net/wireless/mac80211/rt2x00/rt2x00firmware.c:123: warning: implici=
t declaration of function =E2=80=98msleep=E2=80=99

on powerpc. I suppose on your system something pulls in the relevant
header already.

johannes

--=-4E5fjcA+51JoU5+6xm3B
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGcGR3/ETPhpq3jKURAut6AJ9zl13o0NSLm9ZDnpgil/+VB5F0pwCdFvXp
Dr7VNfjdbgnc1q2k/hOgPWY=
=/sT5
-----END PGP SIGNATURE-----

--=-4E5fjcA+51JoU5+6xm3B--

