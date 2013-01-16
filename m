Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37670 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259Ab3APN5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 08:57:42 -0500
Message-ID: <1358344682.22862.4.camel@jlt4.sipsolutions.net> (sfid-20130116_145748_538519_53BA0B56)
Subject: pull-request: iwlwifi-next 2013-01-16
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 16 Jan 2013 14:58:02 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-9QqjtPdkwCpJmHYPJ8VA"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9QqjtPdkwCpJmHYPJ8VA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Please pull a few updates for iwlwifi. These are just some cleanups and
a debug improvement.

Thanks,
johannes


The following changes since commit abae2386d55aff1d395cdb665f03684c227a6a69=
:

  iwlwifi: always check that grab_nic_access succeeds (2013-01-03 15:34:11 =
+0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to 1c3fea82d6ebf33edadefed2d9ce3efa1a654338:

  iwlwifi: improve the reports in TX path (2013-01-16 14:23:57 +0100)

----------------------------------------------------------------
Emmanuel Grumbach (2):
      iwlwifi: allow to zero SRAM
      iwlwifi: improve the reports in TX path

Johannes Berg (4):
      iwlwifi: don't memset scalar values
      iwlwifi: don't enable all interrupts on resuming
      iwlwifi: simplify scheduler memory clearing
      iwlwifi: enable communication with WoWLAN firmware

 drivers/net/wireless/iwlwifi/dvm/mac80211.c  |   8 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c        |  28 +++---
 drivers/net/wireless/iwlwifi/iwl-fh.h        |   4 +
 drivers/net/wireless/iwlwifi/iwl-trans.h     |  32 +++++-
 drivers/net/wireless/iwlwifi/pcie/internal.h |   2 +
 drivers/net/wireless/iwlwifi/pcie/rx.c       |  12 ++-
 drivers/net/wireless/iwlwifi/pcie/trans.c    | 140 ++++++++++++++++++++++-=
----
 drivers/net/wireless/iwlwifi/pcie/tx.c       |  54 +++++++----
 8 files changed, 212 insertions(+), 68 deletions(-)


--=-9QqjtPdkwCpJmHYPJ8VA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQ9rHqAAoJEDBSmw7B7bqrzp4P/0w8xQVe8/WcGki6p8L7VjGt
AUsrkifvsp1eUQJ2PWqAqzMPYLty48XlpwG2hfGZKoPkIcOFN4VStmRMcWEyAYVC
D20ygp2Z2/pEqI5YUm922PyTkjMXqxAt9/gGXUxzGvHIT0zjr5DLs0Up4baRJron
eHQIwkqMnoGDq8840kwPck45/treNKzsfKJiK2e0hmFVlW0w6U+Zwq9tkhVoips2
LoQjCeh9SZTFleUxf0AHITD8ermbLORNFzKSjbqIg5g//lL1hw6bUDHYC9cbbyiR
cJ8exNnfmytnmpI4UTHsJbe2yfDx93x0vLoAyp3zUznkvR5+8v4okpSRcGT+wTNJ
hWkf9plRCzWILUKmiUKwew6XnX3ChbRuup+RiUapce4vCzdgMjyGV3p77RvZpKPu
9fzDYUd6/1osfy5ifrdNid/zXg6y9RyUpu5LDu/lAKmA9UWJpr3MBJhQKyDsXmiV
4XhMoiYUGgVEcgV5nAv24tPR0paNoRMMT+saHDtuSTJbbpI6KNsArjGLThxPMAnT
2zU7Zb5CvLo2g674D5IxaCCBeMLBAUBzifgoh/SkS6v0QYOHYkFg2638+5L9u0QQ
k/L4O2hy1FE2+8ZBrb1I4xzeVjaqT5nqCKFtdwkJJLE6gmn8hrlC5vzSPHLXdytj
OnJDycu5bsi2LE/j/dy5
=9zb5
-----END PGP SIGNATURE-----

--=-9QqjtPdkwCpJmHYPJ8VA--

