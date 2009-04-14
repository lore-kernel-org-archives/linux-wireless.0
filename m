Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:51492 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbZDNKwP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 06:52:15 -0400
Date: Tue, 14 Apr 2009 06:52:00 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Greg KH <greg@kroah.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: [PATCH] Add vt6656 driver to drivers/staging.
Message-ID: <20090414105200.GE25746@storm.local.network> (sfid-20090414_125216_881334_29F40447)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o0ZfoUVt4BxPQnbU"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--o0ZfoUVt4BxPQnbU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This patch adds the vt6656 driver to drivers/staging.  This code was literally
copied from the upstream source archive, available here:

  http://www.viaarena.com/Driver/VT6656_Linux_src_v1.19_12_x86.zip

Copyright: VIA Networking Technologies, Inc.
License: GPL
Authors: Jerry Chen, Kyle Hsu, Lucas Lin, Lyndon Chen, Tevin Chen, Warren Hsu,
         Yiching Chen
Signed-off-by: Forest Bond <forest@alittletooquiet.net>

Patch: http://www.alittletooquiet.net/media/code/0002-Add-vt6656-driver-to-drivers-staging.patch.gz
Signature: http://www.alittletooquiet.net/media/code/0002-Add-vt6656-driver-to-drivers-staging.patch.gz.sig

Thanks,
Forest
--
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--o0ZfoUVt4BxPQnbU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJ5GrQRO4fQQdv5AwRAjRIAKDb73oGJyViwov/yvUomOTKCeQC7wCeJ1Tr
Sq8Nqu8rIJI/wL7AlIyyRv0=
=cloX
-----END PGP SIGNATURE-----

--o0ZfoUVt4BxPQnbU--
