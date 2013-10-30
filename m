Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:41289 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab3J3Rgr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 13:36:47 -0400
Received: by mail-ea0-f179.google.com with SMTP id b10so851978eae.10
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 10:36:46 -0700 (PDT)
Message-ID: <527143AA.5070900@gmail.com> (sfid-20131030_183651_825331_C6DEAE75)
Date: Wed, 30 Oct 2013 19:36:42 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: pull-request: iwlwifi-next 2013-10-07
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="DoItspJudH2aJBpo5aLsmXrDricph5n8h"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DoItspJudH2aJBpo5aLsmXrDricph5n8h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

John,

This the last pull request before merge window opens.

There are a few fixes from Johannes mostly clean up patches. We have
also a few other fixes that are relevant for the new firmware that has
not been released yet.

Tell me about any issues you might face with it. Thanks.

emmanuel

The following changes since commit 246dd9922e859768aa522daa6c1c601785e57e=
0c:

  iwlwifi: mvm: fix operator precedence (2013-10-18 16:02:38 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
for-john

for you to fetch changes up to c92f06a1dea1e444213d860a20023f72c134e20a:

  iwlwifi: mvm: BT Coex - fix copy paste issue (2013-10-30 19:20:48 +0200=
)

----------------------------------------------------------------
Alexander Bondar (1):
      iwlwifi: mvm: update UAPSD support TLV bits

Emmanuel Grumbach (2):
      iwlwifi: mvm: BT Coex fix NULL pointer dereference
      iwlwifi: mvm: BT Coex - fix copy paste issue

Johannes Berg (5):
      iwlwifi: transport config n_no_reclaim_cmds should be unsigned
      iwlwifi: pcie: move warning message into warning
      iwlwifi: mvm: capture the FCS in monitor mode
      iwlwifi: mvm: add missing break in debugfs
      iwlwifi: warn if firmware image doesn't exist

Michael Opdenacker (1):
      iwlwifi: remove duplicate includes

 drivers/net/wireless/iwlwifi/dvm/ucode.c    |    9 ++++-----
 drivers/net/wireless/iwlwifi/iwl-fw.h       |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-io.c       |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans.h    |    2 +-
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c  |    8 ++++++--
 drivers/net/wireless/iwlwifi/mvm/debugfs.c  |    1 +
 drivers/net/wireless/iwlwifi/mvm/fw.c       |    8 +++-----
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c |    8 +++++++-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   14 +++++++++-----
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |    1 -
 drivers/net/wireless/iwlwifi/mvm/ops.c      |    2 +-
 drivers/net/wireless/iwlwifi/mvm/rx.c       |    6 +++++-
 drivers/net/wireless/iwlwifi/pcie/tx.c      |    9 ++++-----
 13 files changed, 43 insertions(+), 29 deletions(-)


--DoItspJudH2aJBpo5aLsmXrDricph5n8h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJScUOtAAoJEC0Llv5uNjIBwkgP/RGrt1Tav5tlB2dGJEbRyK5I
28W9XkLkjVuFNhas/fNgx5XlC2s42xEJ5khoOK/ecRAKHHHBEmxnFC5kKIeihsYs
8eZBeuOWorTYgN5O1Xn9u5T+vRE8MtgberpLngbY8evAmrqAUERbvoJVmSPDNizp
d0dAB7FjsMYSM4Snwm3YAr75w3rYUD5Sz1FDNgQ1O1XiEChPWsLjMopigFbWvErI
fcGpIsuScNSlr7YNqyoudteU+LpeYKNoZ/1U7Z5N3QSLJzStAcmfkNAixNxc5boZ
C7vlumDkkrMA37z4gEMfXgTUEJihHCWBjCJpWYnv9/PDuw1TWQSCGG2hR1Fih2X1
Psz+jo68OIKIVBoazcKu+RQ5PrWOJJLni4UToFz8d2hhlXrN1FWndSVBVXOY7iKr
Orkjel02HILa/GPMRbSdBUWhT+jcSKEE1xn/gMAfo0Hns8g9OKh3nojulIN8OamW
xiY6YtH2euGpYr9LRx0tMtT/H47QGjiakiLIlMIu1clknGlFH029QkpAzNahpeAX
MdKhsinlwXUAhsDPjOneeXv0XCZLwLcETQH8TElAQWOWaUs/dwq0mk+B5VazAn9e
oKbF1Z0siNkLq0egwpHCTrSN371cieG/oe1+K1AGhAKGS5I3KLyUgYDS4P3j1LEk
qwKVqbM1QZcjM1gYeOJ6
=apsa
-----END PGP SIGNATURE-----

--DoItspJudH2aJBpo5aLsmXrDricph5n8h--
