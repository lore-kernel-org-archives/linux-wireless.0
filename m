Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:46957 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbZFFRN3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2009 13:13:29 -0400
Message-ID: <4A2AA3BA.4050200@web.de>
Date: Sat, 06 Jun 2009 19:13:30 +0200
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	otus-devel@lists.madwifi-project.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] ar9170-fw: Use self-built toolchain by default
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD7BB77DA530CBB447F5B61F7"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD7BB77DA530CBB447F5B61F7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---

 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index e0113d6..5fc0868 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # Type is AP or STA
 TYPE ?=3D STA
=20
-PFX ?=3D /usr/share/gnush_v0901_elf-1/bin/sh-elf-
+PFX ?=3D $(shell pwd)/toolchain/inst/bin/sh-elf-
 CC =3D $(PFX)gcc
 LD =3D $(PFX)ld
 AS =3D $(PFX)as



--------------enigD7BB77DA530CBB447F5B61F7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkoqo7oACgkQniDOoMHTA+l2qQCfWnWZBq1RXRfgN1bzN620A66P
FzgAn30tMdPzmtpvT56uCP7MK6LQt/Jd
=dmb1
-----END PGP SIGNATURE-----

--------------enigD7BB77DA530CBB447F5B61F7--
