Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34075 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752259AbcKRInc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 03:43:32 -0500
Received: by mail-pg0-f67.google.com with SMTP id e9so19712429pgc.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2016 00:43:32 -0800 (PST)
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Date: Fri, 18 Nov 2016 00:43:22 -0800
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        Zhaoyang Liu <liuzy@marvell.com>,
        Bing Zhao <bzhao@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Avinash Patil <patila@marvell.com>
Subject: [PATCH 0/7] Fix -Wunused-but-set-variable in mwifiex/
Message-ID: <cover.1479458373.git.kirtika@google.com> (sfid-20161118_094337_507873_0ED7304E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset is part of the effort led by Arnd Bergmann to clean up
warnings in the kernel. This and following patchsets will focus on
"-Wunused-but-set-variable" as it among the noisier ones. These were
found compiling with W=1.

Kirtika Ruchandani (7):
  mwifiex: Removed unused mwifiex_private* 'priv' variable
  mwifiex: Remove unused  'chan_num' variable
  mwifiex: Remove unused 'sta_ptr' variable
  mwifiex: Remove unused 'adapter'variable
  mwifiex: Remove unused 'pm_flag' variable
  mwifiex: Removed unused 'pkt_type' variable
  mwifiex: Remove unused 'bcd_usb' variable

 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 2 --
 drivers/net/wireless/marvell/mwifiex/main.c     | 3 ---
 drivers/net/wireless/marvell/mwifiex/scan.c     | 8 +++-----
 drivers/net/wireless/marvell/mwifiex/sdio.c     | 5 -----
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c  | 2 --
 drivers/net/wireless/marvell/mwifiex/usb.c      | 3 +--
 6 files changed, 4 insertions(+), 19 deletions(-)

--
2.8.0.rc3.226.g39d4020
