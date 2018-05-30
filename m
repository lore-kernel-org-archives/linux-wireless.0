Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37374 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751844AbeE3ORz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 10:17:55 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2018-05-30
Date: Wed, 30 May 2018 17:17:51 +0300
Message-ID: <87vab52po0.fsf@kamboji.qca.qualcomm.com> (sfid-20180530_161801_881214_39CBF7F3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

I now this is late but hopefully this pull request can make it to net
tree and to the final 4.17 release still. But if not, please let me know
and I'll pull this to wireless-drivers-next instead.

More info in the signed tag below, and please let me know if there are
any problems.

Kalle

The following changes since commit 813477aa49aac5deba04eb4956360dde58a0e807:

  MAINTAINERS: change Kalle as wcn36xx maintainer (2018-05-22 15:36:41 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2018-05-30

for you to fetch changes up to ab1068d6866e28bf6427ceaea681a381e5870a4a:

  iwlwifi: pcie: compare with number of IRQs requested for, not number of CPUs (2018-05-29 10:40:25 +0300)

----------------------------------------------------------------
wireless-drivers fixes for 4.17

Two last minute fixes, hopefully they make it to 4.17 still.

rt2x00

* revert a fix which caused even more problems

iwlwifi

* fix a crash when there are 16 or more logical CPUs

----------------------------------------------------------------
Hao Wei Tee (1):
      iwlwifi: pcie: compare with number of IRQs requested for, not number of CPUs

Stanislaw Gruszka (1):
      Revert "rt2800: use TXOP_BACKOFF for probe frames"

 drivers/net/wireless/intel/iwlwifi/pcie/trans.c  | 10 +++++-----
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c |  7 +++----
 2 files changed, 8 insertions(+), 9 deletions(-)
