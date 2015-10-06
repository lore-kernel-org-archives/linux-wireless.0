Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:58980 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbbJFNPn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2015 09:15:43 -0400
Subject: [PATCH 0/2] ath10k: implement board API 2 support
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 06 Oct 2015 16:15:39 +0300
Message-ID: <20151006131455.14278.28222.stgit@potku.adurom.net> (sfid-20151006_151546_511802_13325B96)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement board 2 API to make it easier to have multiple board files and
automatically choose correct one.

---

Manikanta Pubbisetty (2):
      ath10k: add board 2 API support
      ath10k: select board data based on BMI chip id and board id


 drivers/net/wireless/ath/ath10k/bmi.h   |   10 +
 drivers/net/wireless/ath/ath10k/core.c  |  328 +++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/core.h  |   13 +
 drivers/net/wireless/ath/ath10k/debug.c |   16 +-
 drivers/net/wireless/ath/ath10k/hw.h    |   13 +
 drivers/net/wireless/ath/ath10k/pci.c   |   13 +
 6 files changed, 338 insertions(+), 55 deletions(-)

