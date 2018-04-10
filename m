Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:38778 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754274AbeDJPBk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 11:01:40 -0400
Received: by mail-pf0-f193.google.com with SMTP id y69so8530596pfb.5
        for <linux-wireless@vger.kernel.org>; Tue, 10 Apr 2018 08:01:40 -0700 (PDT)
From: Siva Rebbagondla <siva8118@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sushant Mishra <sushant.mishra@redpinesignals.com>
Subject: [v2 0/7] rsi driver improvements
Date: Tue, 10 Apr 2018 20:34:10 +0530
Message-Id: <1523372657-6067-1-git-send-email-siva8118@gmail.com> (sfid-20180410_170145_622161_48FFB6D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

This patch series brings in some improvements in power save, Tx data
path etc.

Changes in v2:
	Below patches are split and created smaller incremental patches[Kalle]
	[08/10] rsi: device disconnect changes
	[09/10] rsi: tx improvements

Amitkumar Karwar (7):
  rsi: disable fw watchdog timer during reset
  rsi: device bootup parameter configuration
  rsi: use appropriate interface for power save configuration
  rsi: increase max supported aggregation subframes
  rsi: parse TID from data frame correctly
  rsi: enable power save by default for coex
  rsi: advertise 5GHz support based on device capability

 drivers/net/wireless/rsi/rsi_91x_core.c     |  4 +++-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 29 ++++++++++++++++++++---------
 drivers/net/wireless/rsi/rsi_91x_usb.c      |  7 +++++++
 drivers/net/wireless/rsi/rsi_boot_params.h  |  3 ++-
 drivers/net/wireless/rsi/rsi_hal.h          |  1 +
 drivers/net/wireless/rsi/rsi_mgmt.h         |  3 +++
 drivers/net/wireless/rsi/rsi_usb.h          |  1 +
 7 files changed, 37 insertions(+), 11 deletions(-)

-- 
2.7.4
