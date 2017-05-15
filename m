Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45044 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756785AbdEOLqE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 May 2017 07:46:04 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH v2 0/5] wil6210 patches
Date: Mon, 15 May 2017 14:45:54 +0300
Message-Id: <1494848759-3651-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170515_134608_454737_C0AF9A48)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches include the following:
- Fix for "low level RF sector API" patch
- Addtotional wil6210 fixes

Hamad Kadmany (2):
  wil6210: add option to load FTM FW
  wil6210: Improve AP stop handling

Lior David (1):
  wil6210: low level RF sector API

Maya Erez (2):
  wil6210: add option to ignore OTA regulatory hints
  wil6210: support devices with different PCIe bar size

 drivers/net/wireless/ath/wil6210/cfg80211.c | 585 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/ioctl.c    |   4 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c |  35 +-
 drivers/net/wireless/ath/wil6210/wil6210.h  |  13 +-
 drivers/net/wireless/ath/wil6210/wmi.c      |   4 +-
 5 files changed, 622 insertions(+), 19 deletions(-)

-- 
1.9.1
