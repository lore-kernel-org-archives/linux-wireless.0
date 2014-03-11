Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:43798 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbaCKLuv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 07:50:51 -0400
Received: by mail-we0-f170.google.com with SMTP id w61so9937404wes.29
        for <linux-wireless@vger.kernel.org>; Tue, 11 Mar 2014 04:50:50 -0700 (PDT)
Message-ID: <531EF845.2050609@gmail.com> (sfid-20140311_125054_733023_5CF85CD9)
Date: Tue, 11 Mar 2014 13:49:25 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi 2014-03-11
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="nu2JUB1x4pGTTlqhbGgWLVOtV0iTmJV3G"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nu2JUB1x4pGTTlqhbGgWLVOtV0iTmJV3G
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi John,

One more bugfix - this bug has been there forever, so it might not be all=
 that much important. Your call.

We were sending a host command while the mutex wasn't held. This led to h=
ard-to-catch races.

Please pull - thanks.


The following changes since commit acfcd9ed588465e48efe5ceb67177096d51c95=
a9:

  iwlwifi: fix and add 7265 series HW IDs (2014-03-04 19:30:06 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git=
 for-john

for you to fetch changes up to 82e5a649453a3cf23516277abb84273768a1592b:

  iwlwifi: dvm: take mutex when sending SYNC BT config command (2014-03-1=
1 13:15:16 +0200)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: dvm: take mutex when sending SYNC BT config command

 drivers/net/wireless/iwlwifi/dvm/main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


--nu2JUB1x4pGTTlqhbGgWLVOtV0iTmJV3G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTHvh+AAoJEC0Llv5uNjIBHfwP/353u0D8zlcZGzyOEbN6ORbk
A8QjWShnPol4GOAPZ9f4WAf7oO8aBfvgZKMUzAaLB5B58FIr5YZ5VgnZvdN6UDSc
/cQ9fR6oL5kXcGEEmJOW0krp6sOJd/Mpml/Oazk8KQfFBF3pmwf8PbvfDaETkaQP
pNsdAmr0r4RralDatfyza4wo0BKvU95e6JUj1vag3+hFWmBx78y6H2nu0mCEt8U5
BvM5TTOHtTTL+D2BZqRZ8ghiOy03TaEQbkzCUAh1A+Sx+b++ILsJ4nw6Y8K6Apim
5UdCWPJjZGm26VQuTLce20a6+wx6XDYalTYLikH9Sk/z39BPFyKohOvoF5P6/wmJ
TASJ4SMbrUiBywGQwsjp5c/wdlBycAMhaQo2Dn1Oc1GysMqb8Uss/56BQ9nzI6eD
B2dn4XvTGyxpf+pi6fravBYYQ9JpKFKHTCsyBsdcrnbEZl/01U3kCSyxuC2mcQh+
VpLLltUrtlZ8QNRUxgwuGcUWBsQYNamuQRbiXTwwFMbyI0zlax55lX2VoHKN/Lx8
76Lhs9pMXiJcNqhcrldClvm+msFw2nrj7prAeEJwa8IcD/HqdGNYrSSc5scQW1gZ
qw7Wu+oxsVfUAJUMjAqLbt01BYUB/SkbwXRpfa8724k8AIZTG7XLP61zp0pXdt0z
87fV37t7g+NEbBpppubl
=oGcH
-----END PGP SIGNATURE-----

--nu2JUB1x4pGTTlqhbGgWLVOtV0iTmJV3G--
