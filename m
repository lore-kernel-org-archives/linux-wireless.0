Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:48746 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbaG0RvN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2014 13:51:13 -0400
Received: by mail-wg0-f49.google.com with SMTP id k14so6342511wgh.32
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jul 2014 10:51:12 -0700 (PDT)
Message-ID: <53D53C0A.6080407@gmail.com> (sfid-20140727_195131_219196_2F4CA2B6)
Date: Sun, 27 Jul 2014 20:51:06 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [ANN]: new experimental firmware for 3160 / 7260 / 7265
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="JwEdTvMlqg9cX6tQS7vMgIPvghENf5dVh"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JwEdTvMlqg9cX6tQS7vMgIPvghENf5dVh
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

We released an experimental firmware for 3160 / 7260 / 7265.

It is available from my linux-firmware.git clone:

3160: https://git.kernel.org/cgit/linux/kernel/git/egrumbach/linux-firmwa=
re.git/plain/iwlwifi-3160-9.ucode?h=3DCore6
7260: https://git.kernel.org/cgit/linux/kernel/git/egrumbach/linux-firmwa=
re.git/plain/iwlwifi-7260-9.ucode?h=3DCore6
7265: https://git.kernel.org/cgit/linux/kernel/git/egrumbach/linux-firmwa=
re.git/plain/iwlwifi-7265-9.ucode?h=3DCore6

We had an issue with the version number in this stream, so I can't releas=
e it officially, nor can I send a pull request to integrate it to linux-f=
irmware.git.
I am working with the firmware team to fix the version issue.
I still would be glad to have more testing on this firmware, so any feedb=
ack would be greatly appreciated.
It has gone through our regular testing cycles, but "field" feedback is a=
lways valuable.

Thanks in advance to anyone who will test it.

New (temporary) version number: 25.223.9.0



--JwEdTvMlqg9cX6tQS7vMgIPvghENf5dVh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT1TwNAAoJEC0Llv5uNjIBYoIQAJtLmNgSJ4rWQoYLWFn/uhEQ
MngLbNyONA3xMvBR8929V0PIC9+l1hQ61Jl15tFL/q5rjS9qifLRdnXU5N6BAnLv
N0rAp6eswxDSBS04M0ZoQYcIoMqY1fZkGRKRkBVozh9byXcVvzFH7TveJj2G51ol
1WbDCNnKN88WFL7s1t5PxHstV7G8PYYjn2pC57h08Oxjx2qk29ZYs7lDGe6gNrq9
x2k4IgEBpEE2z81YUlN03mWukMEps5riAlgcMoIZLifNSA+jsHyP+0XhSdWHGrMo
5kvltQq7M4sPZ98g7N+zwPLVgCjLs1ZUTfvm2y6zGRq2PM797mdjK1YC6j7RqlF3
0j08B0grCeLKFmRnhxD+I7SsHpgAV+rOqSHzYVmVXUNKr8Y8JhDO7PnTUXo18NMs
CuVjUB1LhjVuLgMkrVWGrSX5NRm4oiE7wH6AMNugxxle9tn7fdCw5j0B8Vdt6IRh
ozwGcsNDoATNylS2Sea0tO6TOGh5ZS5/rpzJop0o3hncmcrRPKt9NcWnkJmUjDbR
ZU3PMw1YxIzHkQTDMrUfLDbuqPgE3kkz8XkcqeCDf/pZAasB8+xd0Pd/p/8ZlW+J
7p/srr+WrNxnFrnrMrmP9BEcETRuCLyXVKdWhv/EdDp8BublLxSMWordoQfjuhHw
xxTSFQGFxvsRwa/LwEho
=ngOF
-----END PGP SIGNATURE-----

--JwEdTvMlqg9cX6tQS7vMgIPvghENf5dVh--
