Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:46137 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbeC2OPU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 10:15:20 -0400
Received: by mail-pg0-f68.google.com with SMTP id t12so3129242pgp.13
        for <linux-wireless@vger.kernel.org>; Thu, 29 Mar 2018 07:15:20 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: [v2 0/4] rsi driver enhancements
Date: Thu, 29 Mar 2018 19:32:25 +0530
Message-Id: <1522332149-5100-1-git-send-email-amitkarwar@gmail.com> (sfid-20180329_161524_304896_EE2265D6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

This patch series includes some code rearrangement and roaming related
improvements.

Changes in v2:
v2 1/4 is same as v1 2/10
v2 2/4 is same as v1 3/10
v2 3/4 is same as v1 4/10
v2 4/4 is updated version of v1 5/10

Remaining patches in v1 need major improvements. Couple of them
requires splitting the patch into multiple patches. So they will be
submitted separately.

Prameela Rani Garnepudi (4):
  rsi: move xtend_desc structure from rsi_main.h to rsi_mgmt.h
  rsi: move descriptor preparation to core
  rsi: enable 80MHz clock by default
  rsi: roaming enhancements

 drivers/net/wireless/rsi/rsi_91x_core.c     | 27 +++++++++++
 drivers/net/wireless/rsi/rsi_91x_hal.c      | 73 ++++++++++++++++++-----------
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 18 +++++--
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 34 ++++++++------
 drivers/net/wireless/rsi/rsi_hal.h          |  2 +
 drivers/net/wireless/rsi/rsi_main.h         |  7 +--
 drivers/net/wireless/rsi/rsi_mgmt.h         | 16 ++++++-
 7 files changed, 126 insertions(+), 51 deletions(-)

-- 
2.7.4
