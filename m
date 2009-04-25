Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:46863 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbZDYOdW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 10:33:22 -0400
Date: Sat, 25 Apr 2009 10:32:15 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Greg KH <greg@kroah.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: [PATCH 5/8] Build vt6655.ko, not viawget.ko.
Message-ID: <20090425143215.GE11201@storm.local.network> (sfid-20090425_163325_282261_DB7C5CD8)
References: <20090425001405.GB23173@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ns7jmDPpOpCD+GE/"
In-Reply-To: <20090425001405.GB23173@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Ns7jmDPpOpCD+GE/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Build vt6655.ko, not viawget.ko.

Signed-off-by: Forest Bond <forest@alittletooquiet.net>
---
 drivers/staging/vt6655/device_cfg.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vt6655/device_cfg.h b/drivers/staging/vt6655/d=
evice_cfg.h
index 9e18f7c..6af9067 100644
--- a/drivers/staging/vt6655/device_cfg.h
+++ b/drivers/staging/vt6655/device_cfg.h
@@ -86,7 +86,7 @@ struct _version {
 #define VCAM_SIZE           32
 #define TX_QUEUE_NO         8
=20
-#define DEVICE_NAME         "viawget"
+#define DEVICE_NAME         "vt6655"
 #define DEVICE_FULL_DRV_NAM "VIA Networking Solomon-A/B/G Wireless LAN Ada=
pter Driver"
=20
 #ifndef MAJOR_VERSION
--=20
1.5.4.3


--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--Ns7jmDPpOpCD+GE/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJ8x7vRO4fQQdv5AwRAsYgAKCagj7PT06YhgKiiD1hEbh5nvBWmgCgkHbA
rvydM1dIeNi5NvnuxljlJyw=
=w/f5
-----END PGP SIGNATURE-----

--Ns7jmDPpOpCD+GE/--
