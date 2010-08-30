Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42271 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372Ab0H3SOp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 14:14:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: me@bobcopeland.com, johannes@sipsolutions.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath5k: eliminate warning unintialized variable warning
Date: Mon, 30 Aug 2010 14:11:53 -0400
Message-Id: <1283191913-3155-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath5k/base.c:1317: warning: ‘ret’ may be used uninitialized in this function

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 0 files changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/ath/base.c

diff --git a/drivers/net/wireless/ath/base.c b/drivers/net/wireless/ath/base.c
new file mode 100644
index 0000000..e69de29
-- 
1.7.2.2

