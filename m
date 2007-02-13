Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59853 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbXBMSoO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 13:44:14 -0500
Subject: network manager vs. missing firmware
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Dan Williams <dcbw@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gopN4OhA0JVME8vDfyUh"
Date: Tue, 13 Feb 2007 19:41:46 +0100
Message-Id: <1171392106.10344.100.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gopN4OhA0JVME8vDfyUh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Just remembered this issue from last year's summit and figured I'd bring
it up again since we never made progress on it.

Is there any idea other than standardising on a new error code
-ENOFIRMWARE that can be returned from device up or association or
wherever makes sense for the driver. Or do we also mandate that it be
returned on device up, and for example never on module load? I think
it's mostly a question of documentation/driver acceptance policy/driver
review as well as a question of whether we can get a new error code into
the kernel or not.........

johannes

--=-gopN4OhA0JVME8vDfyUh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF0gZq/ETPhpq3jKURAgyzAJ9cIoIc1r8KMs2/FIaF3QoKPmlAOwCgmBh/
FeUcaTT3E5f90d8jr8jpC74=
=4uTI
-----END PGP SIGNATURE-----

--=-gopN4OhA0JVME8vDfyUh--

