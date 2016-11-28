Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60660 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932094AbcK1LtK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 06:49:10 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 0/4] wil6210 patches
Date: Mon, 28 Nov 2016 13:48:59 +0200
Message-Id: <1480333743-7306-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20161128_124914_598464_52B45FC2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Various wil6210 bug fixes.

Lior David (3):
  wil6210: delay remain on channel when scan is active
  wil6210: add debugfs blobs for UCODE code and data
  wil6210: align to latest auto generated wmi.h

Maya Erez (1):
  wil6210: validate wil_pmc_alloc parameters

 drivers/net/wireless/ath/wil6210/cfg80211.c       |  45 ++-
 drivers/net/wireless/ath/wil6210/main.c           |   2 +
 drivers/net/wireless/ath/wil6210/p2p.c            | 150 +++++++--
 drivers/net/wireless/ath/wil6210/pmc.c            |  55 ++-
 drivers/net/wireless/ath/wil6210/wil6210.h        |  12 +-
 drivers/net/wireless/ath/wil6210/wil_crash_dump.c |   6 +
 drivers/net/wireless/ath/wil6210/wmi.c            |  43 ++-
 drivers/net/wireless/ath/wil6210/wmi.h            | 392 +++++++++++++++-------
 8 files changed, 495 insertions(+), 210 deletions(-)

-- 
1.9.1
