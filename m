Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:33687 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab3IHOz3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Sep 2013 10:55:29 -0400
Subject: [PATCH 0/8] ath10k: boot, bmi and mac debug message cleanup
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 08 Sep 2013 17:55:25 +0300
Message-ID: <20130908145435.3136.49168.stgit@localhost6.localdomain6> (sfid-20130908_165541_291902_1CFCCA2F)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simple message log cleanup. Please review.

---

Kalle Valo (8):
      ath10k: add BMI log level
      ath10k: rename ATH10K_DBG_CORE to BOOT
      ath10k: cleanup debug messages in core.c
      ath10k: add boot debug messages to pci.c and ce.c
      ath10k: add boot debug messages to htc.c
      ath10k: add boot messages to htt.c
      ath10k: clean mac.c debug messages
      ath10k: print phymode as a string


 drivers/net/wireless/ath/ath10k/bmi.c    |   42 ++++---
 drivers/net/wireless/ath/ath10k/ce.c     |    8 +
 drivers/net/wireless/ath/ath10k/core.c   |   11 +-
 drivers/net/wireless/ath/ath10k/debug.h  |    3 
 drivers/net/wireless/ath/ath10k/htc.c    |   16 +--
 drivers/net/wireless/ath/ath10k/htt_rx.c |    2 
 drivers/net/wireless/ath/ath10k/htt_tx.c |    2 
 drivers/net/wireless/ath/ath10k/mac.c    |  185 ++++++++++++++++--------------
 drivers/net/wireless/ath/ath10k/pci.c    |    6 +
 drivers/net/wireless/ath/ath10k/wmi.h    |   42 +++++++
 10 files changed, 197 insertions(+), 120 deletions(-)

