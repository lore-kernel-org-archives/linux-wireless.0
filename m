Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49972 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753489AbeAIM7m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 07:59:42 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2018-01-09
Date: Tue, 09 Jan 2018 14:59:37 +0200
Message-ID: <87d12j193a.fsf@kamboji.qca.qualcomm.com> (sfid-20180109_140030_938218_7200983A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

My first pull request in 2018 so Happy New Year!

This is for 4.15 to the net tree. Only two fixes this time so should be
an easy pull.

This is quite late due to the holidays but it has been pretty quiet so I
guess I wasn't the only one trying to not touch the computer ;) And
Linus said that he will be releasing -rc8 anyway so this shouldn't be
that late.

Please let me know if you have any problems.

Kalle


The following changes since commit a41886f56b7bbb88e6a23b5d738a94f2632142a4:

  Merge tag 'iwlwifi-for-kalle-2017-12-05' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes (2017-12-07 15:50:34 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2018-01-09

for you to fetch changes up to 49fdde89e2b8574cb55f99b57b7798f44567bc4b:

  Merge ath-current from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2018-01-05 14:02:36 +0200)

----------------------------------------------------------------
wireless-drivers fixes for 4.15

Hopefully the last set of fixes for 4.15.

iwlwifi

* fix DMA mapping regression since v4.14

wcn36xx

* fix dynamic power save which has been broken since the driver was commited

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: pcie: fix DMA memory mapping / unmapping

Kalle Valo (1):
      Merge ath-current from git://git.kernel.org/.../kvalo/ath.git

Loic Poulain (1):
      wcn36xx: Fix dynamic power saving

 drivers/net/wireless/ath/wcn36xx/main.c            | 23 +++++++++++-----------
 drivers/net/wireless/ath/wcn36xx/pmc.c             |  6 ++++--
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h | 10 +++++++---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  | 11 +++--------
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  8 ++++----
 5 files changed, 30 insertions(+), 28 deletions(-)
