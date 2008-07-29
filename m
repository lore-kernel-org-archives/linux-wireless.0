Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17151 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090AbYG2Fru (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 01:47:50 -0400
Received: from mail.atheros.com ([192.168.11.2])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 22:47:50 -0700
From: <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>,
	Sujith Manoharan <smanoharan@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 16/16] ath9k: Remove some unused macros
Date: Mon, 28 Jul 2008 22:47:25 -0700
Message-ID: <d1ed7eb640a14dc4ea01c86e3f533877014bb73d.1217309552.git.lrodriguez@atheros.com> (sfid-20080729_081543_874415_46120C93)
In-Reply-To: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
References: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <smanoharan@atheros.com>

diff --git a/drivers/net/wireless/ath9k/regd.h b/drivers/net/wireless/ath9k/regd.h
index 6d6c89f..125941c 100644
--- a/drivers/net/wireless/ath9k/regd.h
+++ b/drivers/net/wireless/ath9k/regd.h
@@ -19,9 +19,6 @@
 
 #include "ath9k.h"
 
-#define ATH9K_MODE_11A_TURBO  ATH9K_MODE_SEL_108A
-#define ATH9K_MODE_11G_TURBO  ATH9K_MODE_SEL_108G
-
 #define BMLEN 2
 #define BMZERO {(u_int64_t) 0, (u_int64_t) 0}
 
-- 
1.5.4.3

