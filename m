Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:60978 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751102AbXBZFXe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Feb 2007 00:23:34 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: John Linville <linville@tuxdriver.com>
Subject: d80211-drivers pull request (week08)
Date: Mon, 26 Feb 2007 00:22:54 -0500
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Andrea Merello <andrea.merello@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2610272.elXoZgvkj7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702260022.59486.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2610272.elXoZgvkj7
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi John,

Please pull
git://git.kernel.org/pub/scm/linux/kernel/git/mwu/d80211-drivers.git
for these patches:

p54-week08 branch:
Christian Lamparter (1):
      p54: fix reloading issues with (mini-)pci adapters

zd1211rw-week08 branch:
Michael Wu (2):
      zd1211rw-d80211: fix zd_mac_open error path
      zd1211rw-d80211: remove requested_channel

rtl818x-week08 branch:
Michael Wu (1):
      rtl818x: Add RTL8187 driver

Common to all branches:
Michael Wu (1):
      adm8211, p54, zd1211rw-d80211: remove skb_headroom check

Yup, there's a new driver in there. It's for the Realtek 8187, found on=20
Netgear WG111v2 and probably elsewhere too. It still needs work but it work=
s=20
well enough for more people to test now. Thanks to Andrea Merello for helpi=
ng=20
out with its development and thanks to Realtek for supporting Linux!

=2DMichael Wu

--nextPart2610272.elXoZgvkj7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF4m6zT3Oqt9AH4aERAov7AJ4txuXz8Q5i327ktTk/dZagJRdbwQCfdaHZ
MWbmlPgrbqq3XrwB1uvIZR8=
=dM16
-----END PGP SIGNATURE-----

--nextPart2610272.elXoZgvkj7--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
