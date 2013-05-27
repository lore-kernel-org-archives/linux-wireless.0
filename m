Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51752 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab3E0Jgs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 05:36:48 -0400
Message-ID: <1369647404.8229.26.camel@jlt4.sipsolutions.net> (sfid-20130527_113651_044051_B3247150)
Subject: pull-request: iwlwifi-fixes 2013-05-27
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 27 May 2013 11:36:44 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-4+Azb90OibtUXneBO6pT"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4+Azb90OibtUXneBO6pT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

And here's a pull request for iwlwifi-fixes ...

This fixes a brown paper-bag bug that we really should've caught in
review. More details in the changelog for the fix.

johannes


The following changes since commit e3d4bc8cc0230e8dc8033484666f03f87392a8c4=
:

  iwlwifi: mvm: fix aggregation drain flow (2013-05-16 22:39:07 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git f=
or-john

for you to fetch changes up to a87783699b23395c46bbeeb5d28f6db24897bf26:

  iwlwifi: dvm: fix zero LQ CMD sending avoidance (2013-05-27 11:33:57 +020=
0)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: dvm: fix zero LQ CMD sending avoidance

 drivers/net/wireless/iwlwifi/dvm/sta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


--=-4+Azb90OibtUXneBO6pT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRoyksAAoJEDBSmw7B7bqrp9YQAMu3PWCcxgk4tvlhkytLj1Ht
aO7wfLQtV831BKX76gIiWRNmwdViF+eQSTA6CJn8WeZCbmeOSKUg1AULQGugLNvn
TkI0v+bfehUw8cMgKhs0hX4laiLojVJfwycqShgZrAPBS8BtT55I6TRBn88Jbgk+
Vya1R/DtTcMdvYaATALfdqYNrgGbt+/6gfhcvDHfHS8xNTQjre+riVowNDXLbBzr
PFIaFbRbFgJo1eZf7yfkEZSOPryeNqancBOfsjTrSCpT9DYGo8VhlL0fLD0xTrbA
GE+fedJMZbv8FFCWdX4+88LEqRTjSbXI7KYxIRCa43eQEYErKes4L/QrEKutfLqu
dizsOfEXmpgEYflYBryqufBCKmiX5RnXJWvSgEaNtxsh9lYM4PUGYSDxGQIhGeYf
+QL2d4C/b1yPUCeB5Z8YUeRsOy9sWZD16Vu6IUx58kzdlzzDVIrkGhDB7jYCnLwI
VPkA8zUcS+c0s76YRn7L6RB00k2OnCdKB1qPbWHtkYRk1+PkE8bStNyJxSLYKgSH
Mbetvyp8VVSkA9HvKeNxZfB4sJ4t8Wd2vgTn7Rua5iMa4Fb1DqM9dGwUSlSWlUye
jOSOYci+XaavCiAfiWkxrhxSv7VU+j8v5P14/uyxo3qstFZ0+jV3Y5MZW5YMSyMf
CGYigp1Il7iVa1SWAD3u
=l8uM
-----END PGP SIGNATURE-----

--=-4+Azb90OibtUXneBO6pT--

