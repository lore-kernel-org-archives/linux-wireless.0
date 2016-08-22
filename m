Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11984 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751168AbcHVJn3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 05:43:29 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 0/4] wil6210 patches
Date: Mon, 22 Aug 2016 12:42:18 +0300
Message-Id: <1471858942-23766-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160822_114335_724528_2F775A52)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Various wil6210 fixes

Lior David (4):
  wil6210: fix protection of wil->scan_request
  wil6210: align to latest auto generated wmi.h
  wil6210: extract firmware capabilities from FW file
  wil6210: extract firmware version from file header

 drivers/net/wireless/ath/wil6210/cfg80211.c |   3 +
 drivers/net/wireless/ath/wil6210/debugfs.c  |  53 ++++-
 drivers/net/wireless/ath/wil6210/fw.h       |  14 +-
 drivers/net/wireless/ath/wil6210/fw_inc.c   |  92 ++++++---
 drivers/net/wireless/ath/wil6210/main.c     |   9 +-
 drivers/net/wireless/ath/wil6210/netdev.c   |   2 +
 drivers/net/wireless/ath/wil6210/pcie_bus.c |   4 +
 drivers/net/wireless/ath/wil6210/wil6210.h  |   9 +-
 drivers/net/wireless/ath/wil6210/wmi.c      |  12 +-
 drivers/net/wireless/ath/wil6210/wmi.h      | 292 ++++++++++++++++++++++++++++
 10 files changed, 454 insertions(+), 36 deletions(-)

-- 
1.9.1
