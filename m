Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43615 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965606AbXBOO7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 09:59:20 -0500
Subject: renaming in debugfs?
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Greg KH <greg@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-L1dLS/S3hOkRYQfXbBDp"
Date: Thu, 15 Feb 2007 12:52:53 +0100
Message-Id: <1171540374.20204.2.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-L1dLS/S3hOkRYQfXbBDp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

For the wiphy stuff I wanted to provide a debugfs as well as a sysfs dir
for drivers (or the d80211 stack).

But then I decided that stable wiphy names will be a good thing instead
of just numbering them wiphy%d. Does anyone have any idea how to rename
directories in debugfs? I guess that for sysfs it'll just work if I
change the kobject name, but maybe that's wrong too?

johannes

--=-L1dLS/S3hOkRYQfXbBDp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF1EmU/ETPhpq3jKURAjlCAKCRV3dfEUHeRIY2mPg9TUMQB3XgJACdE0q5
z+dzrr7Qdt2yUI/ITjDiytg=
=jDKJ
-----END PGP SIGNATURE-----

--=-L1dLS/S3hOkRYQfXbBDp--

