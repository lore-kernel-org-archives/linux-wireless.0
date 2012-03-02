Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:41495 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932367Ab2CBBl5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 20:41:57 -0500
Received: from zeta.dmz-us.st.com (ns4.st.com [167.4.16.71])
	by beta.dmz-us.st.com (STMicroelectronics) with ESMTP id 9693D5F
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 01:41:42 +0000 (GMT)
Received: from relay1.stm.gmessaging.net (unknown [10.230.100.17])
	by zeta.dmz-us.st.com (STMicroelectronics) with ESMTP id 248FF55
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 00:13:06 +0000 (GMT)
Received: from exdcvycastm003.EQ1STM.local (alteon-source-exch [10.230.100.61])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(Client CN "exdcvycastm003", Issuer "exdcvycastm003" (not verified))
	by relay1.stm.gmessaging.net (Postfix) with ESMTPS id D443324C2C0
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 02:41:52 +0100 (CET)
From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 19/21] cw1200: TODO list.
Date: Fri, 2 Mar 2012 02:41:33 +0100
Message-ID: <1330652495-25837-20-git-send-email-dmitry.tarnyagin@stericsson.com> (sfid-20120302_024214_419049_90816933)
In-Reply-To: <1330652495-25837-1-git-send-email-dmitry.tarnyagin@stericsson.com>
References: <d53e019b1a0bcd29c2c367fbe5665413f2d33938-submit>
 <1330652495-25837-1-git-send-email-dmitry.tarnyagin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just a TODO list for the driver.

Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
---
 drivers/staging/cw1200/TODO |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/cw1200/TODO

diff --git a/drivers/staging/cw1200/TODO b/drivers/staging/cw1200/TODO
new file mode 100644
index 0000000..8967a29
--- /dev/null
+++ b/drivers/staging/cw1200/TODO
@@ -0,0 +1,7 @@
+TODO:
+        - IBSS: Not implemented. Consider as obsolete?
+	- Convert bh thread to a realtime workqueue.
+	- Submit mac80211 CQM (beacon miss, tx fail) changes
+	  and reenable CQM extensions in the driver.
+	- Align filters in pm.c with wowlan filters.
+	- Different suspend strategy for Linux and Android.
-- 
1.7.9

