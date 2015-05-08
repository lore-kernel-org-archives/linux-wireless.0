Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:51164 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbbEHTMX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2015 15:12:23 -0400
From: =?UTF-8?q?Lauri=20Kentt=C3=A4?= <lauri.kentta@gmail.com>
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, trivial@kernel.org,
	=?UTF-8?q?Lauri=20Kentt=C3=A4?= <lauri.kentta@gmail.com>
Subject: [PATCH] rtlwifi: rtl8188ee: Fix pwrseqcmd.h include path.
Date: Fri,  8 May 2015 22:01:53 +0300
Message-Id: <1431111713-32615-1-git-send-email-lauri.kentta@gmail.com> (sfid-20150508_211229_274586_346C91CE)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lauri Kenttä <lauri.kentta@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.c | 2 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.c b/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.c
index ef28c8e..02013df 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.c
@@ -23,7 +23,7 @@
  *
  *****************************************************************************/
 
-#include "pwrseqcmd.h"
+#include "../pwrseqcmd.h"
 #include "pwrseq.h"
 
 /* drivers should parse below arrays and do the corresponding actions */
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.h b/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.h
index 7910334..f2d9c61 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.h
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.h
@@ -26,7 +26,7 @@
 #ifndef __RTL8723E_PWRSEQ_H__
 #define __RTL8723E_PWRSEQ_H__
 
-#include "pwrseqcmd.h"
+#include "../pwrseqcmd.h"
 /* Check document WM-20110607-Paul-RTL8188EE_Power_Architecture-R02.vsd
  *	There are 6 HW Power States:
  *	0: POFF--Power Off
-- 
2.4.0

