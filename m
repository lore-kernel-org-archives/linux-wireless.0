Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:42510 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab0HVTrK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Aug 2010 15:47:10 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh05-2.mail.saunalahti.fi (Postfix) with SMTP id BD1AA8C28F
	for <linux-wireless@vger.kernel.org>; Sun, 22 Aug 2010 22:47:08 +0300 (EEST)
Received: from potku.valot.fi (a85-156-250-252.elisa-laajakaista.fi [85.156.250.252])
	by emh06.mail.saunalahti.fi (Postfix) with ESMTP id 29FC1E51A3
	for <linux-wireless@vger.kernel.org>; Sun, 22 Aug 2010 22:47:05 +0300 (EEST)
Subject: [PATCH 4/4] wl1251: move include guard after the license
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Sun, 22 Aug 2010 22:47:02 +0300
Message-ID: <20100822194702.16660.99182.stgit@potku.valot.fi>
In-Reply-To: <20100822194615.16660.21195.stgit@potku.valot.fi>
References: <20100822194615.16660.21195.stgit@potku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 drivers/net/wireless/wl12xx/wl1251_ps.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_ps.h b/drivers/net/wireless/wl12xx/wl1251_ps.h
index 98ed6c2..e5db81f 100644
--- a/drivers/net/wireless/wl12xx/wl1251_ps.h
+++ b/drivers/net/wireless/wl12xx/wl1251_ps.h
@@ -1,6 +1,3 @@
-#ifndef __WL1251_PS_H__
-#define __WL1251_PS_H__
-
 /*
  * This file is part of wl1251
  *
@@ -23,6 +20,9 @@
  *
  */
 
+#ifndef __WL1251_PS_H__
+#define __WL1251_PS_H__
+
 #include "wl1251.h"
 #include "wl1251_acx.h"
 

