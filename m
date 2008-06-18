Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aktaia.intevation.org ([212.95.126.10]:46296 "EHLO
	kolab.intevation.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752206AbYFRPVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 11:21:43 -0400
From: Bernhard Reiter <bernhard@intevation.de>
To: linux-wireless@vger.kernel.org
Subject: 802.11 pccard, Agere 0x0156,0x0003?
Date: Wed, 18 Jun 2008 17:15:12 +0200
Cc: Greg KH <greg@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2438132.Dji62gI3s3";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200806181715.20516.bernhard@intevation.de> (sfid-20080618_172151_205409_ECF04355)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2438132.Dji62gI3s3
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

[Greg gave me the hint to ask here. Please CC me on relevant replies. No ne=
ed=20
to further include him, unless this should go up on the "DriverNeeded" page=
=20
later I presume.]

Sitting here a  pc card wireless land adapter.=20
id 0x0156, 0x0003, which probably makes it an Agere card.
cardctl info says:
"Wireless PC Card Model 0110"

We bought it quite a while ago under the tradename Lancom Airlancer MC-11
from Lancom Systems.=20
http://www.lancom-systems.de/AirLancer-MC-11b.117.0.html

Background: We bought it because we thought it has a supported chipset based
on the old orinocco driver. The vendor announces "linux" supported, but thi=
s=20
turned out to be only a driver for Linux 2.4.x.
Some old stuff (with picture) can be found at:=20
ftp://ftp.lancom.de/AirLancer/AirLancer-11/AirLancer-MC-11
this seems to be Free Software under GNU GPLv2 even.

We could not get it to work with 2.6 and searching the web gave us only=20
reports that it does not work with kernel 2.6.x.
See http://questier.com/howto.html#Proxim
(the "local copy" links might haver newer source code)

I've grepped the kernel sources (2.6.24) to try to find the id in a driver
or the source code comment "Agere" to see if source code was taken in from=
=20
the 2.4. driver. To no prevail.
Even pages like=20
http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Linux.Wireless.drivers=
=2E802.11b.html
do not help me.

So I cannot really say: is there a driver which should work with this card =
in=20
Linux 2.6.x and just missed the manufacturer id to recognise it?
Where did the old Free Software code go? Was it never ported to 2.6?

Thanks,
Bernhard
[Please CC me on relevant replies.]

=2D-=20
Managing Director - Owner: www.intevation.net       (Free Software Company)
Germany Coordinator: fsfeurope.org. Coordinator: www.Kolab-Konsortium.com.
Intevation GmbH, Osnabr=C3=BCck, DE; Amtsgericht Osnabr=C3=BCck, HRB 18998
Gesch=C3=A4ftsf=C3=BChrer Frank Koormann, Bernhard Reiter, Dr. Jan-Oliver W=
agner

--nextPart2438132.Dji62gI3s3
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkhZJogACgkQh9ag3dpKERbI8wCeKGpBLFw3zi+shwjbNMv3tqNh
wv8AnRQE28VVE1bfyboXJcyTyWlwXM9R
=l09r
-----END PGP SIGNATURE-----

--nextPart2438132.Dji62gI3s3--
