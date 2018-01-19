Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18602 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755030AbeASPhK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 10:37:10 -0500
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, Maya Erez <merez@codaurora.org>
Subject: [PATCH 0/8] wil6210 patches
Date: Fri, 19 Jan 2018 17:36:56 +0200
Message-Id: <1516376224-13976-1-git-send-email-merez@codeaurora.org> (sfid-20180119_163719_160652_F7647897)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following patches add support for new wil6210 device
and general fixes.

Dedy Lansky (1):
  wil6210: support flashless device

Lior David (2):
  wil6210: fix random failure to bring network interface up
  wil6210: enlarge FW mac_rgf_ext section for Sparrow D0

Maya Erez (5):
  wil6210: add Talyn PCIe device ID
  wil6210: recognize Talyn JTAG ID
  wil6210: add support for Talyn AHB address map
  wil6210: configure OTP HW vectors in SW reset flow
  wil6210: support parsing brd file address from fw file

 drivers/net/wireless/ath/wil6210/boot_loader.h |   9 +-
 drivers/net/wireless/ath/wil6210/fw.h          |  18 ++-
 drivers/net/wireless/ath/wil6210/fw_inc.c      | 167 +++++++++++++++++--
 drivers/net/wireless/ath/wil6210/interrupt.c   |   6 +-
 drivers/net/wireless/ath/wil6210/main.c        | 216 ++++++++++++++++++++++---
 drivers/net/wireless/ath/wil6210/pcie_bus.c    |  46 +++++-
 drivers/net/wireless/ath/wil6210/wil6210.h     |  55 ++++++-
 drivers/net/wireless/ath/wil6210/wmi.c         |  90 +++++++++--
 8 files changed, 549 insertions(+), 58 deletions(-)

-- 
1.9.1
