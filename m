Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:14588 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751322AbdGRL5o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Jul 2017 07:57:44 -0400
From: <mpubbise@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCHv2 0/3] TDLS support on 10.4 firmware
Date: Tue, 18 Jul 2017 17:28:11 +0530
Message-ID: <1500379094-2373-1-git-send-email-mpubbise@qti.qualcomm.com> (sfid-20170718_135749_286032_399511AA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>

This patchset adds TDLS support on 10.4 firmwares.

Manikanta Pubbisetty (3):
  ath10k: extend wmi service map to accommodate new services
  ath10k: add tdls support for 10.4 firmwares
  ath10k: push peer type to target for TDLS peers

V2:
  - Commit log corrections
  - Some spellcheck corrections

 drivers/net/wireless/ath/ath10k/core.c |    9 ++
 drivers/net/wireless/ath/ath10k/hw.h   |    5 +
 drivers/net/wireless/ath/ath10k/mac.c  |    5 +-
 drivers/net/wireless/ath/ath10k/wmi.c  |  162 +++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h  |  270 +++++++++++++++++++++++++++++++-
 5 files changed, 449 insertions(+), 2 deletions(-)

-- 
1.7.9.5
