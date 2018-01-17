Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53496 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752491AbeAQOa0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 09:30:26 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2018-01-17
Date: Wed, 17 Jan 2018 16:30:21 +0200
Message-ID: <87wp0gd0ci.fsf@kamboji.qca.qualcomm.com> (sfid-20180117_153058_852207_2D26CDEC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

here are few more important fixes to the net tree for 4.15, I hope they
still make it. Please let me know if there are any problems.

Kalle


The following changes since commit 49fdde89e2b8574cb55f99b57b7798f44567bc4b:

  Merge ath-current from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2018-01-05 14:02:36 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2018-01-17

for you to fetch changes up to cc124d5cc8d81985c3511892d7a6d546552ff754:

  brcmfmac: fix CLM load error for legacy chips when user helper is enabled (2018-01-16 21:17:32 +0200)

----------------------------------------------------------------
wireless-drivers fixes for 4.15

One last set of fixes for regression submitted during the last few days.

bcma & ssb

* fix older build problems which (apparently) recently became more
  frequent in certain MIPS configurations

brcmfmac

* continue driver initialisation even if CLM blob (firmware) file is
  not found

----------------------------------------------------------------
Guenter Roeck (1):
      bcma: Fix 'allmodconfig' and BCMA builds on MIPS targets

James Hogan (1):
      ssb: Disable PCI host for PCI_DRIVERS_GENERIC

Wright Feng (1):
      brcmfmac: fix CLM load error for legacy chips when user helper is enabled

 drivers/bcma/Kconfig                                      | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 9 +++------
 drivers/ssb/Kconfig                                       | 2 +-
 3 files changed, 5 insertions(+), 8 deletions(-)
