Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:11683 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbbEJKN6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 May 2015 06:13:58 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Note about Intel Wireless device 3165
Date: Sun, 10 May 2015 10:13:53 +0000
Message-ID: <1431252828.7475.7.camel@intel.com> (sfid-20150510_121401_571323_B3835DBB)
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-a1C/uc3KMkmM66KD459l"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-a1C/uc3KMkmM66KD459l
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I got a few questions off-list about 3165. This device is new and it
belongs to the 7265 family. It uses the same firmware as 7265 but has a
few limitations. We had issues with this device and these issues are now
fixed in my tree that feeds Linus's tree [1].
You'll need the very new iwlwifi-7265D-13.ucode firmware to work with
this device. This very new firmware is available in my
linux-firmware.git clone [2] and in the wiki page [3].
We aim at supporting this device starting from kernel 4.1.

I hope this clarifies a bit the situation.
Thank you.

[1] https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/iwlwifi-fixes.git/
[2] https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/linux-firmware.git=
/
[3] https://wireless.wiki.kernel.org/en/users/Drivers/iwlwifi#firmware

--=-a1C/uc3KMkmM66KD459l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABAgAGBQJVTy9cAAoJEC0Llv5uNjIBx2MP/2xc42C+Gnr1pi+GABuE+igJ
qgGWC5lgKfbLlaounGNCT7Ccurd7IvdseXzqfVQY1ZojoDd8qgWAOnN9/celAzJt
u40sf7E+a0n5T95TP8wexdjKQQvg/Ovk2QyWrwj/+bv2M3s1NitMTUR8YDK0iFKf
RD3RAH1ylcEhtAUWI7K+I2CEWHxv3wE1U1pcYeF5Zbgd8kRkCsYzXWT6YOlz+o1C
mGUkyWKSCumD3RVqSfpt8df2YydompUEaLivnpzqYNVvM9gTC267d7u/IYRdp/tq
70jteiSjfw7wILBxunD55lofNZ/NKvOSqfyXm2oHVIXwlV40wTUCt6KAjiCxHNo1
F55JBHwzfYZWB9Pf+jLsapP7goKKDWNirxPmDrKFCxiN8MmJ4GOC188x9q9xWj70
ncCXui6V+HN6BDYfqTu57s3YjyNfUC20wZj1NBXTLYkpybXqi+3Ijv7SB5ZO5ZVs
8uIIF8Z8Ywy6ds/GXx1orwySVQ4Jh2N/KEc6QRWNf6dLOFnVSko7+ndhk+UVxRTh
LX+8ocSE4qsfRKowQSzr/QPW+uJ7s0POzGuDF+k20uxHlfh1KEtZssdNtz59P136
DI6g6880zG+KJM8I9uX7155Wh9kOS/MunyqWQRHdkXMTvBLlUfRHSF6sx3gRxBN9
v5QSuRuD713qfeW0Fz1m
=Vuc4
-----END PGP SIGNATURE-----

--=-a1C/uc3KMkmM66KD459l--
