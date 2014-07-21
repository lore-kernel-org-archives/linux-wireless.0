Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:51306 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbaGUSKW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 14:10:22 -0400
Received: by mail-wi0-f176.google.com with SMTP id bs8so4659385wib.3
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2014 11:10:21 -0700 (PDT)
Message-ID: <53CD5785.80408@gmail.com> (sfid-20140721_201027_948112_EF6E8AE4)
Date: Mon, 21 Jul 2014 21:10:13 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi 2014-07-21
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="rjE5AEP4cSenv7sRnj3R7WHXWa9SHt6HX"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rjE5AEP4cSenv7sRnj3R7WHXWa9SHt6HX
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

This is a pull request for 3.16.

It includes a merge damage fix. This region has been changed in -next and=
 -fixes quite a few times and apparently, I failed to handle it properly,=
 so here the fix.
Along with that I have a fix from Eliad to properly handle overlapping BS=
S in AP mode.

Let me know if you have issues with this.
Thanks!

The following changes since commit dc271ee0d04d12d6bfabacbec803289a7072fb=
d9:

  iwlwifi: mvm: disable CTS to Self (2014-07-03 20:55:18 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git=
 master

for you to fetch changes up to 4601879419f94a89fcbf427b4d3bfbf4ce294174:

  iwlwifi: mvm: pass beacons from foreign APs (2014-07-21 10:38:25 +0300)=


----------------------------------------------------------------
Eliad Peller (1):
      iwlwifi: mvm: pass beacons from foreign APs

Emmanuel Grumbach (1):
      iwlwifi: mvm: fix merge damage

 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 15 +++++++++++++--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  7 -------
 2 files changed, 13 insertions(+), 9 deletions(-)


--rjE5AEP4cSenv7sRnj3R7WHXWa9SHt6HX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTzVeIAAoJEC0Llv5uNjIB0kwP/jKGSEOHf0SdU9tRBcJRyWxi
P66Kxux3GJqFZ6DyiisZZGvxCflPjSJSvO6jyZ7x3m2smTIRYYB+rV9Ar7wUdsks
cqi0y8cR3gdLnfXdTuAdpTu3WbSX2QCGKyacdwDS/D+M84M871/1dK5iptfdrDKV
dlGv+K2nzmJ/yv4rmeO+0p8tBanlGNcrJx8+TMlLOc5wpXiF+GcRxeqeCP39POT5
6Q6wnTB1eoMj6aBgVzd7d36+BCJkVyJijnczqvmkuIG+IdTJA3LERuRWhZ0L8agZ
h5gNyur768W9MkhwCSW/ig738dPUnlRz+eJR6clo7v5FsACK/6AViyB3zdwbEMA5
mHaBMsQAy8TitHDKEWtyQFX9twN3TGEAfrsvLYqKCMmM5Pmfnsb4+oKhupGuJzba
CqVkuWk5ssISHtRV/fijxpDJvkBoRLwHdctPJ+oaLdoF7V04YbuiWti6mFSEo/TM
81xwUMSD3J1VOEgCmV9OvkyWhyLB8IfC2Y4lUbhzNGa02r860QVR6zEeGptvwzzv
SIxncQvg6JHvZdAp+bIHT5NJfq0zei/N/aqzsGmTTwOuXIy7vKfqktnHe/D72NfS
A/tKFzll/3NcGugFbtj8H/nMtu4Pe2zhgnRp4VqmUhAH02/zX8zWDPfM208c0Qcd
jgKZZmJO2JuUZ9VHy9Qa
=vD3Y
-----END PGP SIGNATURE-----

--rjE5AEP4cSenv7sRnj3R7WHXWa9SHt6HX--
