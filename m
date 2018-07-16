Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f42.google.com ([209.85.160.42]:33552 "EHLO
        mail-pl0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727313AbeGPODg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Jul 2018 10:03:36 -0400
Received: by mail-pl0-f42.google.com with SMTP id 6-v6so15263530plb.0
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jul 2018 06:36:07 -0700 (PDT)
From: Siva Rebbagondla <siva8118@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Amol Hanwate <amol.hanwate@redpinesignals.com>
Subject: [PATCH 0/6] rsi: miscellaneous driver cleanups
Date: Mon, 16 Jul 2018 19:09:31 +0530
Message-Id: <1531748377-29215-1-git-send-email-siva8118@gmail.com> (sfid-20180716_153610_678574_343E5CF5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

This patch set consists some miscellaneous driver cleanups for
Redpine wlan driver.

Amol Hanwate (3):
  rsi: Correct RSI_NEEDED_HEADROOM in mac80211_attach.
  rsi: fill rx_params only once.
  rsi: move init_done flag to end of rsi_91x_init().

Siva Rebbagondla (3):
  rsi: remove redundant device ids
  rsi: remove redundant flash_content variable
  rsi: add firmware support for AP+BT dual mode

 drivers/net/wireless/rsi/rsi_91x_hal.c  | 26 ++++++++++----------------
 drivers/net/wireless/rsi/rsi_91x_main.c |  7 +------
 drivers/net/wireless/rsi/rsi_91x_sdio.c |  5 +----
 drivers/net/wireless/rsi/rsi_91x_usb.c  |  6 +-----
 drivers/net/wireless/rsi/rsi_mgmt.h     |  2 +-
 drivers/net/wireless/rsi/rsi_sdio.h     |  3 +++
 drivers/net/wireless/rsi/rsi_usb.h      |  3 +++
 7 files changed, 20 insertions(+), 32 deletions(-)

-- 
2.5.5
