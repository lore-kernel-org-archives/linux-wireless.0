Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:37955 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122AbaGTO0d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:26:33 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com,
	Fabian Frederick <fabf@skynet.be>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 10/30] rtlwifi: rtl8188ee: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:25:11 +0200
Message-Id: <1405866332-24652-1-git-send-email-fabf@skynet.be> (sfid-20140720_163355_771919_9FB0F483)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.c b/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.c
index a9cfa13..0f93142 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.c
@@ -125,7 +125,6 @@ bool rtl88_hal_pwrseqcmdparsing(struct rtl_priv *rtlpriv, u8 cut_version,
 				RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 					 "rtl88_hal_pwrseqcmdparsing(): PWR_CMD_END\n");
 				return true;
-				break;
 			default:
 				RT_ASSERT(false,
 					  "rtl88_hal_pwrseqcmdparsing(): Unknown CMD!!\n");
-- 
1.9.1

