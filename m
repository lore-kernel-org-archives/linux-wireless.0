Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:55335 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab1LPSx2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 13:53:28 -0500
Subject: [PATCH 0/2] ath6kl: firmware API 3 support
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Fri, 16 Dec 2011 20:53:20 +0200
Message-ID: <20111216185200.18442.29650.stgit@localhost6.localdomain6> (sfid-20111216_195331_180491_55F34A1E)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First some refactoring to make it easier to extend the firmware handling
and then a patch adding support for firmware API 3.

---

Kalle Valo (2):
      ath6kl: handle firmware names more dynamically
      ath6kl: add support for FW API 3


 drivers/net/wireless/ath/ath6kl/core.h |   46 +++++++------
 drivers/net/wireless/ath/ath6kl/init.c |  113 +++++++++++++++++---------------
 drivers/net/wireless/ath/ath6kl/sdio.c |   16 ++---
 drivers/net/wireless/ath/ath6kl/usb.c  |    5 +
 4 files changed, 98 insertions(+), 82 deletions(-)

