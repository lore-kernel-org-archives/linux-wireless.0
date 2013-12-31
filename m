Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:43102 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab3LaR03 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:26:29 -0500
Received: by mail-ee0-f45.google.com with SMTP id d49so5503908eek.18
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:26:28 -0800 (PST)
Message-ID: <52C2FE41.3080409@gmail.com> (sfid-20131231_182632_827946_3FFD7A97)
Date: Tue, 31 Dec 2013 19:26:25 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>, hui.xiao@intel.com
Subject: pull request: firmware for Intel Wireless adapter - 7260 / 3160
References: <CANUX_P3EwRW=+1SwHQN81hKKGZiVBFDcmLZAqknXZE+UzL_fTA@mail.gmail.com>
In-Reply-To: <CANUX_P3EwRW=+1SwHQN81hKKGZiVBFDcmLZAqknXZE+UzL_fTA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="l47AFSkMjF34jfkc3QUaG1nWD6QMSW0Ls"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--l47AFSkMjF34jfkc3QUaG1nWD6QMSW0Ls
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Ben,

This is another pull request for another firmware. I am sorry not to
have put this together in the same pull request, but I just didn't know
when that new firmware would come out.
It doesn't replace the older one:
* iwlwifi-{7260,3160}-7.ucode is supported starting from 3.10
* iwlwifi-{7260,3160}-8.ucode is supported starting from 3.13

This is why I don't remove the -7.ucode.
At some point (maybe around 3.15) we will stop supporting -7.ucode.
Thanks!

The following changes since commit 52d77db9f133afe4d2b26aeccfd603745f45fd=
a1:

  Merge branch 'master' of
git://git.kernel.org/pub/scm/linux/kernel/git/egrumbach/linux-firmware
(2013-12-30 15:22:40 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/egrumbach/linux-firmware
master

for you to fetch changes up to 11fdbda75cebef71e878fd0dfa6bfca984be35f4:

  iwlwifi: update firmware for 7260 / 3160 devices (2013-12-30 18:59:33
+0200)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: update firmware for 7260 / 3160 devices

 WHENCE               |    6 ++++++
 iwlwifi-3160-8.ucode |  Bin 0 -> 662032 bytes
 iwlwifi-7260-8.ucode |  Bin 0 -> 674628 bytes
 3 files changed, 6 insertions(+)
 create mode 100644 iwlwifi-3160-8.ucode
 create mode 100644 iwlwifi-7260-8.ucode



--l47AFSkMjF34jfkc3QUaG1nWD6QMSW0Ls
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSwv5BAAoJEC0Llv5uNjIByAQP/2277uylzQELj30/2ULwU+mg
80tVe0zq3Ier4ifoZSXp1iZrMOE6j4Yg9uNyk/W6f98Vua3f68L1PvfQTpftOGPY
m+SwQrSuU8h16KQgn11CAqgyit6KT5kOqEY0NZ9H7a67Ec8HpuyT1qg+GxkWU0ll
o4XYRH+dblih3Pnd0W9lD8LcEnp8da5FEaZJwyAQlttGeIa542wPsZWangnOkl/b
P47Qx7vfYkmRYBdevgY+BBsvJ6yoRgM9HAn3QEXGQRDdKy+20qh7r2lH6DNM0q9h
tiafSAQ/S+Hc70o7REBjXuacoLMnU+lUqyJU7ImOYBbZxHHNMkcx3i7UIu8DEonx
CrbSSFv2c6D+oRukLU8mtY+V6JYXuZ4rdbi5E9bU4O+Tf0FGX9Paor3Lu6NyuaiA
KcZRVT5p5hKlc+z8C5Ma8921og8slzbVb5z1rjdv93eXAe5lDcfAJ2vMjuzi+yQ0
LyssT65ZfD36FBYMxAUvt8/XE8AvwgCzNP+OoTB5WfEQlrvq1D7fArJ9173s6ukU
FhjEdOOK6zy5O3yQg0YS5XCVqNnZBW2EFNvHclnaHS/vm5sOomTulwpsiS/RvnJ0
P6ZXuT5+IZClYn5d+ozX5jUDeYMZU2Pelo6N4Zx425Z4Z2ea2Nm51jOoZEVkL1i5
ajys1LFqmKbXPouEfgt2
=Lv0l
-----END PGP SIGNATURE-----

--l47AFSkMjF34jfkc3QUaG1nWD6QMSW0Ls--
