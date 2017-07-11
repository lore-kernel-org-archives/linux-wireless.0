Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:25085 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755513AbdGKN4p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Jul 2017 09:56:45 -0400
From: <mpubbise@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
        Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>
Subject: [PATCH 0/3] TDLS support on 10.4 firmware
Date: Tue, 11 Jul 2017 19:26:15 +0530
Message-ID: <1499781378-858-1-git-send-email-mpubbise@qti.qualcomm.com> (sfid-20170711_155649_740569_A9927E16)
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

 drivers/net/wireless/ath/ath10k/core.c |    9 ++
 drivers/net/wireless/ath/ath10k/hw.h   |    5 +
 drivers/net/wireless/ath/ath10k/mac.c  |    5 +-
 drivers/net/wireless/ath/ath10k/wmi.c  |  162 ++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h  |  256 +++++++++++++++++++++++++++++++-
 5 files changed, 435 insertions(+), 2 deletions(-)

-- 
1.7.9.5
