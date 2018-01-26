Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40352 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751219AbeAZQdm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 11:33:42 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2018-01-26
Date: Fri, 26 Jan 2018 18:33:33 +0200
Message-ID: <87zi50shpe.fsf@kamboji.qca.qualcomm.com> (sfid-20180126_173450_871547_2D87FF93)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

this is a pull request to the net tree for 4.15. I hate to do late pull
requests like this but today Sven Joachim found a serious regression in
one of ssb patches, I hope there's still enough time to get this to
4.15.

But if it's too late, just let me know and I'll queue this for 4.16.

Kalle

The following changes since commit 1e19c4d689dc1e95bafd23ef68fbc0c6b9e05180:

  net: vrf: Add support for sends to local broadcast address (2018-01-25 21:51:03 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2018-01-26

for you to fetch changes up to a9e6d44ddeccd3522670e641f1ed9b068e746ff7:

  ssb: Do not disable PCI host on non-Mips (2018-01-26 16:55:34 +0200)

----------------------------------------------------------------
wireless-drivers fixes for 4.15

ssb

* last minute patch to fix b43 and b44 drivers on non-mips platforms,
  a regression from v4.15-rc9

----------------------------------------------------------------
Sven Joachim (1):
      ssb: Do not disable PCI host on non-Mips

 drivers/ssb/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
