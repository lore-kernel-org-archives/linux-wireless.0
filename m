Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46465 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379AbZJATq5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 15:46:57 -0400
Subject: Re: Linux-2.6.32-rc1/2] wext refactor needs wpasupplicant 0.7.0+?
From: Johannes Berg <johannes@sipsolutions.net>
To: Sedat Dilek <sedat.dilek@googlemail.com>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <2d0a357f0910010247jfda1199h5a9b873233b186ca@mail.gmail.com>
References: <2d0a357f0910010247jfda1199h5a9b873233b186ca@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LpHrHcW8cy3P2pBoZQB/"
Date: Thu, 01 Oct 2009 21:47:01 +0200
Message-Id: <1254426421.3959.29.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LpHrHcW8cy3P2pBoZQB/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-10-01 at 11:47 +0200, Sedat Dilek wrote:

> a few hours ago I compiled a new kernel from upstream and put
> wireless-testing master-2009-09-30 on top of it.
>=20
> Last commit a1bec0ecfc76281d5e1ebd33435c67da7dd0fe71
> wext: refactor
>=20
> linux-2.6/master:
> 84d88d5: Merge branch 'sched-fixes-for-linus' of
> git://git./linux/kernel/git/tip/linux-2.6-tip
>=20
> After installation of the above described kernel, I could not connect
> to my AP using wext driver and wpasupplicant (0.6.9-3) from Debian/sid
> [1].
> With ath5k I could not establish a network connection neither via DHCP
> nor via static-IP to my AP (iwl3945 on a second machine works with
> self-debianized wpasupplicant 0.7.0+ and static-IP, same kernel).
>=20
> Just for clarification:
> Does wext refactor need a wpasupplicant >=3D 0.7.0 from hostap GIT reposi=
tory [2]?

Should be ok. Can we see wpa_supplicant -ddt log please?

johannes

--=-LpHrHcW8cy3P2pBoZQB/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKxQcyAAoJEODzc/N7+Qma8+oP/jp6wJZSCwi0CDLtYGtkVMJ1
JCa6hrrBWksvWtEyAIManbtgzQxS6m0SHipLF4Q/nEINlOpkSaHP+oR09mSZ1EfS
ACh0xfaWFqa1X14cMX60ji0kRxMRqEnoGy4zVuMzV4Y46wxkeIwXb5g/Fem3W7IZ
X8qVXjlf+M78/77/XdRb9Jbwr8j/b1AFsYjuauGLZ9x1fWcca3BuFnZ3OQYOc2k5
sEgKQAaDlsqVPUwX8oleqtc6Mky9e4Qqe0dySfXcvyMNkdFLN/oZ2Sr8uCUJRqc7
+iMqcqEYJb9v39KpHjhQSE7/NKJ6RFqePrqOdKMx/DTaXXKATLICtwynYZ5wky0n
PbeKLfOlBNWwjQzHK43Rx61yILB54YurKPr8ij/LZ9lJ3nFqCyYsnpb8PbAiZdwj
Z19sSNp9Dl0Jif9K1bFGWr+H/8aP0FTPQWFEDEqhG7IsNzUzLpMBKLEhaRPcDO6Z
x7DwkOzdY5I/mMESBnrVKwKqT8EXuSIZmKJEOHQxV8wq03x1ClHqH9YxlZT8vTbQ
FRd6uDiAts0dLStjYpSPMnP+G33iEOvJhdpgdWoXwmu5/O8IEKgXCS2WdTsu4UFy
+Uleka/0bCBIkDrsPP0U3+q8SN5KQ8CUMbwBTx7V3/ki8kHudTtmEk677EOM3szk
XqVGwkK6BSLLat9kVJXZ
=AU1Y
-----END PGP SIGNATURE-----

--=-LpHrHcW8cy3P2pBoZQB/--

