Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:49874 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbbKYNiB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 08:38:01 -0500
Subject: [PATCH 0/6] ath10k: print crc32 checksum
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 25 Nov 2015 15:37:56 +0200
Message-ID: <20151125133654.25507.10863.stgit@potku.adurom.net> (sfid-20151125_143805_445008_61B5850A)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Print crc32 checksum for firmware and board files. Also some improvements how
we print info messages during boot.

---

Kalle Valo (6):
      ath10k: fix otp board id error message
      ath10k: reorganise hardware and firmware info messages
      ath10k: always show bmi chip ids and subdevice ids
      ath10k: split driver info messages during device initialisation
      ath10k: print crc32 checksums for firmware and board files
      ath10k: implement fw_checksums debugfs file


 drivers/net/wireless/ath/ath10k/Kconfig |    1 
 drivers/net/wireless/ath/ath10k/core.c  |    8 ++
 drivers/net/wireless/ath/ath10k/debug.c |  119 ++++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/debug.h |    4 +
 4 files changed, 111 insertions(+), 21 deletions(-)

