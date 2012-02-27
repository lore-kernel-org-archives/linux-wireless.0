Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33525 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750819Ab2B0FdY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 00:33:24 -0500
Message-ID: <1330320802.8460.105.camel@deadeye> (sfid-20120227_063327_782741_C11A1DED)
Subject: iwlwifi WPA-TKIP crypto failure after group rekeying
From: Ben Hutchings <ben@decadent.org.uk>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	651199@bugs.debian.org, Andreas Gustafsson <olangu@impressions.se>,
	Marco d'Itri <md@Linux.IT>,
	Gabriel Kerneis <kerneis@pps.jussieu.fr>
Date: Mon, 27 Feb 2012 05:33:22 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-R4QuqudnzoYxd1JsQkVU"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-R4QuqudnzoYxd1JsQkVU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Several Debian users (cc'd) have reported a regression in iwlagn in
Linux 3.1, not fixed in 3.2.  The full bug log is at:

http://bugs.debian.org/651199

To summarise, a WPA-TKIP managed connection stops passing traffic and
the kernel log shows the message "WPA: Group rekeying".  This apparently
doesn't happen if the connection is in heavy use at the time or with
module parameter swcrypto=3D1.  WPA2 is not affected either.

Ben.

--=20
Ben Hutchings
Q.  Which is the greater problem in the world today, ignorance or apathy?
A.  I don't know and I couldn't care less.

--=-R4QuqudnzoYxd1JsQkVU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUAT0sVoue/yOyVhhEJAQp8XhAAwH6GBX5T69c1cV5Dvk3l7gxERaHyjEKA
akaZX4KU2ofdiH3pnedqgp8Ribxguv5RnG/tknOVdlc0hVB/N/NFLKDCWuieubAK
VIK2Rz2DOjjgq48bwU+3BdpRhHlnYYIFKnX/tSuRYKOBBZmaaTkgqe0wJ5vAmqaX
Bx8QbWhddDA2jl1++5kWT1O8ubu6Ec3vBuTKbEVyi+7sJnHdk9bFO5kC/rQXeilj
AfkycAojTAhrIYzEv1NfW8Bl9oKnMa3BeX8/RWwLKCjIrqw9bPifD8fKLaoYUGF4
6yBeQ3iYqWxyIdgz3yMa31x2n1FPFLRAyqtXUBIDTtBdydB2XcE+yfveO9oDAK7M
CmkndnH5RgelqhQPX8uNFvIseHLnwBamcx71Epzpq6241kCbjMuChaYHGdRRsVAJ
edZ+kajL4r4fzrhIyMnifUfMMIW0sovvBv4NHBcPasN42uyCsvaay3nygxLQKP4Q
+sBTPK/BrX9RdV/DdfCvO2F0GigvZRPmkCRgiTV4yQO7PDWUmFVfk3g3XVV8+xpa
l+rdc/SbcdTJlfZ5pHLEGub187LGGvqoyWMTe2sJUgb0M5H2ig4dzQF2V1UFsSqY
CN6j3bK4t6Sfv3LYn0sMW7G1+f8KwVO/By5cE76IojmrIz+NMA5gXCyAxU1hO38I
iVDBKDG+wU4=
=fIdk
-----END PGP SIGNATURE-----

--=-R4QuqudnzoYxd1JsQkVU--
