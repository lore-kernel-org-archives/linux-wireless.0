Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:65003 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbYKYIe4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 03:34:56 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2008 00:34:56 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18731.47093.136313.241884@gargle.gargle.HOWL> (sfid-20081125_093501_010605_C4CE6816)
Date: Tue, 25 Nov 2008 14:01:49 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH] ath9k: Remove core.c, missed in the earlier code scrub patch.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 0 files changed, 0 insertions(+), 0 deletions(-)
 delete mode 100644 drivers/net/wireless/ath9k/core.c

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
deleted file mode 100644
index e69de29..0000000
-- 
1.6.0.3

