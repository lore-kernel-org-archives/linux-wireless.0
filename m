Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:46760 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbZDYOch (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 10:32:37 -0400
Date: Sat, 25 Apr 2009 10:32:04 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Greg KH <greg@kroah.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: [PATCH 4/8] Add necessary EXTRA_CFLAGS to
	drivers/staging/vt6655/Makefile.
Message-ID: <20090425143204.GD11201@storm.local.network> (sfid-20090425_163242_226207_1F01D022)
References: <20090425001405.GB23173@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+B+y8wtTXqdUj1xM"
In-Reply-To: <20090425001405.GB23173@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--+B+y8wtTXqdUj1xM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Add necessary EXTRA_CFLAGS to drivers/staging/vt6655/Makefile.

Signed-off-by: Forest Bond <forest@alittletooquiet.net>
---
 drivers/staging/vt6655/Makefile |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/vt6655/Makefile b/drivers/staging/vt6655/Makef=
ile
index c9e0936..7d76e7e 100644
--- a/drivers/staging/vt6655/Makefile
+++ b/drivers/staging/vt6655/Makefile
@@ -1,3 +1,7 @@
+# TODO: all of these should be removed
+EXTRA_CFLAGS +=3D -DLINUX -D__KERNEL__ -DMODULE  -DEXPORT_SYMTAB -D__NO_VE=
RSION__
+EXTRA_CFLAGS +=3D -DHOSTAP
+
 vt6655-y +=3D	device_main.o \
 	card.o \
 	mac.o \
--=20
1.5.4.3


--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--+B+y8wtTXqdUj1xM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJ8x7kRO4fQQdv5AwRAi2uAJ4mJxRQ3D7yFaZZkeIPzHrp5JVsmwCdGB/4
jwaXkXS1HBnFsTYd3BIsWqk=
=mFP8
-----END PGP SIGNATURE-----

--+B+y8wtTXqdUj1xM--
