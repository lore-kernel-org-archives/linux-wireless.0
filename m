Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:43652 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaJMGko (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2014 02:40:44 -0400
Subject: [PATCH 0/3] ath10k: cal file support
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 13 Oct 2014 09:40:40 +0300
Message-ID: <20141013063929.30315.41969.stgit@potku.adurom.net> (sfid-20141013_084057_430143_105C82A3)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

this adds support for loading calibration data from a file as discussed some
time ago. Please review.

Kalle

---

Kalle Valo (3):
      ath10k: add back enum ath10k_bus
      ath10k: refactor ath10k_init_download_firmware()
      ath10k: retrieve calibration data from file


 drivers/net/wireless/ath/ath10k/core.c  |  107 +++++++++++++++++++++++++------
 drivers/net/wireless/ath/ath10k/core.h  |   36 ++++++++++
 drivers/net/wireless/ath/ath10k/debug.c |    5 +
 drivers/net/wireless/ath/ath10k/hw.h    |    4 +
 drivers/net/wireless/ath/ath10k/pci.c   |    1 
 5 files changed, 129 insertions(+), 24 deletions(-)

