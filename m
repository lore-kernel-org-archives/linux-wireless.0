Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:42017 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756575Ab2CBU1K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 15:27:10 -0500
Received: from zeta.dmz-ap.st.com (ns6.st.com [138.198.234.13])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 19FDDCC
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 20:18:40 +0000 (GMT)
Received: from relay1.stm.gmessaging.net (unknown [10.230.100.17])
	by zeta.dmz-ap.st.com (STMicroelectronics) with ESMTP id B3154A73
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 20:27:04 +0000 (GMT)
Received: from exdcvycastm003.EQ1STM.local (alteon-source-exch [10.230.100.61])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(Client CN "exdcvycastm003", Issuer "exdcvycastm003" (not verified))
	by relay1.stm.gmessaging.net (Postfix) with ESMTPS id 0878B24C2C0
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 21:26:54 +0100 (CET)
From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCHv2 19/21] cw1200: TODO list.
Date: Fri, 2 Mar 2012 21:26:41 +0100
Message-ID: <1330720003-15866-20-git-send-email-dmitry.tarnyagin@stericsson.com> (sfid-20120302_212727_340523_C0A8AF19)
In-Reply-To: <1330720003-15866-1-git-send-email-dmitry.tarnyagin@stericsson.com>
References: <983b0e2d75af161b8e4dec02fc3497926a0080df-submit>
 <1330720003-15866-1-git-send-email-dmitry.tarnyagin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just a TODO list for the driver.

Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
---
 drivers/net/wireless/cw1200/TODO |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/cw1200/TODO

diff --git a/drivers/net/wireless/cw1200/TODO b/drivers/net/wireless/cw1200/TODO
new file mode 100644
index 0000000..f40fd20
--- /dev/null
+++ b/drivers/net/wireless/cw1200/TODO
@@ -0,0 +1,8 @@
+TODO:
+	- IBSS: Not implemented. Consider as obsolete?
+	- Convert bh thread to a realtime workqueue.
+	- Submit mac80211 CQM (beacon miss, tx fail) changes
+	  and reenable CQM extensions in the driver.
+	- Align filters in pm.c with wowlan filters.
+	- Different suspend strategy for Linux and Android.
+	- Get use of traceing instead of printing in datapath.
-- 
1.7.9

