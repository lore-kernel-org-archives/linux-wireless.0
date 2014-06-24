Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:47104 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaFXTiI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:38:08 -0400
Received: by mail-we0-f178.google.com with SMTP id x48so878850wes.37
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:38:06 -0700 (PDT)
Message-ID: <53A9D396.1020306@gmail.com> (sfid-20140624_213812_348507_3482AB78)
Date: Tue, 24 Jun 2014 22:37:58 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: pull request: iwlwifi 2014-06-24
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="51fRANmkQTXxPl3K4Ih4H9M69K22lMIOk"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--51fRANmkQTXxPl3K4Ih4H9M69K22lMIOk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

I have been travelling so this comes a bit late. Nevertheless, it is rela=
tively small.

I have here a fix from Eliad for scheduled scan: it fixes a firmware asse=
rtion. Arik reverts a patch I made that didn't take into account that 316=
0 doesn't have UAPSD and hence, we can't assume that all newer firmwares =
support the feature. Here too, the visible effect is a firmware assertion=
=2E Along with that, we have a few fixes and additions to the device list=
=2E

Please tell me if you have problems. Thanks!

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b3=
8f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git=
 for-john

for you to fetch changes up to a42c9fcc4a88cdd246fab3bcf06c4487afee3d88:

  Revert "iwlwifi: remove IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT flag" (2014-0=
6-24 22:01:46 +0300)

----------------------------------------------------------------
Arik Nemtsov (1):
      Revert "iwlwifi: remove IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT flag"

Eliad Peller (1):
      iwlwifi: mvm: rework sched scan channel configuration

Oren Givon (1):
      iwlwifi: update the 7265 series HW IDs

 drivers/net/wireless/iwlwifi/iwl-fw.h       |  1 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  7 +++++++
 drivers/net/wireless/iwlwifi/mvm/scan.c     | 65 +++++++++++++++++++----=
------------------------------------------
 drivers/net/wireless/iwlwifi/pcie/drv.c     |  3 ++-
 4 files changed, 29 insertions(+), 47 deletions(-)


--51fRANmkQTXxPl3K4Ih4H9M69K22lMIOk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTqdObAAoJEC0Llv5uNjIB2aUQAIvw7/fRwPJF8qwjlw3yuj7P
XrVk8cZVWl0ClCqzJ1K5XLp2Dl2A402s5F5KO2dsMSUoBCXTl4l7E/a8x5YIS3/V
ud9n1258zMOU018FIpeE+IYSzEH3Oh6gW3qKLUmID+9Fi7qqXaW+u2dPF4Qnf5VK
Z4ihoyxdUG/nN1yGYlufHaHaO1uXyVmH47FPW+6xNDcYAYYtt+zHaDRPNIft+6z4
iEliyIsyy2LTIEzdS/T3SktCsrLESE+jDEeaeEPp8VqbdKcA+ycIM04tCkZ2gozP
IcBuHxOvrRpBU9rHTZMgQNfGtUlqs/2saCH0bxg4Hqau91ZvN99L7pZYfH+gmraK
9cSRwZEqek0o1ghxsYxQpIdiBX1r3sn59sEoBG/5OPqVAWDSV4rZUoQQ6rvDakEz
cyWl9rt+bphG4DrCwAeA1rdBPzRSgEXtoTXE4SIR5xms/4f5qc4KektjSVVZisiQ
uM2YM3h5b2+F3t/Tq96UEXJDS7RCuorLKLZm+4WpDfAP2nKmxhmcHGUfZWaDjxUp
jHcjl7CpglMLsW1Qz5V71IxFLBN6VGxYmTfweFBlhHuSgUrRbg/kucDgZoug45yD
GZcu4kZZjf6Pdpbl5M+gfzhayfZuBlbPsDUELOi1iiiQdgE/WwSZpwCwN1eSnsiN
ep/VZgmYFWn0BcdTMdKs
=reF4
-----END PGP SIGNATURE-----

--51fRANmkQTXxPl3K4Ih4H9M69K22lMIOk--
