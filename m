Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:45640 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab3IYVI1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 17:08:27 -0400
Subject: [PATCH 0/3] ath10k: implement FW IE support
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Sep 2013 00:08:20 +0300
Message-ID: <20130925210455.2596.36889.stgit@localhost6.localdomain6> (sfid-20130925_230846_946716_A1F8BE6C)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FW IE format is needed for ath10k automatically detect what features the
firmware image supports. This is important especially with 10.x firmwares which
has a different interface.

Please review.

---

Kalle Valo (3):
      ath10k: rename board_data in struct ath10k
      ath10k: store separate pointers for firmware data
      ath10k: implement firmware IE container support


 drivers/net/wireless/ath/ath10k/core.c |  210 +++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/core.h |   12 ++
 drivers/net/wireless/ath/ath10k/hw.h   |   19 +++
 drivers/net/wireless/ath/ath10k/wmi.c  |    3 
 4 files changed, 220 insertions(+), 24 deletions(-)

