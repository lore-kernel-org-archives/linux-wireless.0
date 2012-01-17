Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:56746 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab2AQNFn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 08:05:43 -0500
Subject: [PATCH 2/3] ath6kl: remove -D__CHECK_ENDIAN__ from Makefile
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Tue, 17 Jan 2012 15:05:32 +0200
Message-ID: <20120117130532.22832.21443.stgit@localhost6.localdomain6> (sfid-20120117_140545_640972_B9BA80DB)
In-Reply-To: <20120117130519.22832.29908.stgit@localhost6.localdomain6>
References: <20120117130519.22832.29908.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As drivers/net/wireless/ath/Makefile contains the flag to enable
endian checks there's no need to have it in ath6kl makefile anymore.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/Makefile |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/Makefile b/drivers/net/wireless/ath/ath6kl/Makefile
index 7070693..e24b617 100644
--- a/drivers/net/wireless/ath/ath6kl/Makefile
+++ b/drivers/net/wireless/ath/ath6kl/Makefile
@@ -33,5 +33,3 @@ ath6kl-y += txrx.o
 ath6kl-y += wmi.o
 ath6kl-y += sdio.o
 ath6kl-$(CONFIG_NL80211_TESTMODE) += testmode.o
-
-ccflags-y += -D__CHECK_ENDIAN__

