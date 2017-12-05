Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49106 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752602AbdLEOhH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 09:37:07 -0500
Message-ID: <1512484624.4827.187.camel@coelho.fi> (sfid-20171205_153740_827742_07EDFA02)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Tue, 05 Dec 2017 16:37:04 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-RLUObsWoHQEWrPR657CZ"
Mime-Version: 1.0
Subject: pull-request: iwlwifi 2017-12-05
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RLUObsWoHQEWrPR657CZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here is my third set of fixes for 4.15.  The most important fixes are
for the new 9000 series where we were not handling some offloads
correctly and secure connections were totally broken.  There is also 4
new PCI IDs and an ROC fix on P2P.  More details in the tag
description.

I have sent this out before and kbuildbot didn't find any issues.=20
Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 5c3de777bdaf48bd0cfb43097c0d0fb85056cab7=
:

  brcmfmac: change driver unbind order of the sdio function devices (2017-1=
2-02 17:22:47 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git t=
ags/iwlwifi-for-kalle-2017-12-05

for you to fetch changes up to bf19037074e770aad74b3b90f37b8b98db3f3748:

  iwlwifi: mvm: mark MIC stripped MPDUs (2017-12-05 16:23:30 +0200)

----------------------------------------------------------------
Third batch of iwlwifi patches intended for 4.15.

* Tell mac80211 when the MAC has been stripped (9000 series);
* Tell mac80211 when the IVC has been stripped (9000 series);
* Add 2 new PCI IDs, one for 9000 and one for 22000;
* Fix a queue hang due during ROC.

----------------------------------------------------------------
David Spinadel (1):
      iwlwifi: mvm: enable RX offloading with TKIP and WEP

Ihab Zhaika (1):
      iwlwifi: add new cards for 9260 and 22000 series

Johannes Berg (1):
      iwlwifi: mvm: flush queue before deleting ROC

Sara Sharon (1):
      iwlwifi: mvm: mark MIC stripped MPDUs

 drivers/net/wireless/intel/iwlwifi/iwl-trans.h      |  4 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h        |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c       | 14 +++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 24 +++++++++++++++++=
+++++--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c       |  2 ++
 5 files changed, 40 insertions(+), 6 deletions(-)
--=-RLUObsWoHQEWrPR657CZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlomrxAACgkQoUecoho8
xfptRRAAlPy5KQAPpHeEIKn1AaMmiOpSQ1pzwQB+ShiOMmwKnuVDYVkpq6UD1ou2
eiWj7Z9dWYc8ARYJ0xzfSd4t3B6ZRBAAWsR9lkfEGEa4MGdkHO7twqoY25v8Hc7w
ZXg7axulf28QXlgS8i4fpfr0X3XEcoQ8ohTE8PkgJalz+kRrbAQef/QG8/25FSIQ
Z1k7IoMldn6vX3Q8mKPImM7sk3B9sUHTP+PQdPAM5T5MZPEAo1I6hl8MbSRAKmSd
zqvh0LKka0BHdlTiHM/QjS6GIP3YF8wRbiQXH6ufNFiuraevWSjd95Ki41Ot5Xk8
bwv3T6MSgks+gQehw5XQCzSBL0KGvnYHeyTCdmv6zFhBV2aQNsGIbohhZM7I5rhE
W+g4qCZNSIgmQhfNP+l+r4iC9BrbQx1DofcYeN+z/oEettSUhQ9FkOIBUTM66zWd
3umv6P6noYNkO3vuh6JiHQ4cSjyDpMMAEkvM0ImnuP/nF5rfI+BDPKpVNqZWhG9E
ZvJ61WM1AP+HhPy8LORbG0pb3/t4OHGgOGYWu1jfoa8xv40gqBcKI/WGwpOPVer9
g4ti/qHgUR6OZiQq7DYWNNSojbRfnZeosOfSwGtzoLvIjVHrNS+rKbu9GR5yf7tJ
QtAGixHzhFl6iGXahrdJzHSk2kw4+FLbDiEZmlccOdRtDy5tX3s=
=DhL3
-----END PGP SIGNATURE-----

--=-RLUObsWoHQEWrPR657CZ--
