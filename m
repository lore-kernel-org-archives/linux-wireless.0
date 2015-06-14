Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db3on0131.outbound.protection.outlook.com ([157.55.234.131]:9679
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751276AbbFNDQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2015 23:16:18 -0400
From: "Joglekar, Tejas (T.)" <tjogleka@visteon.com>
To: "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
	"Jes.Sorensen@redhat.com" <Jes.Sorensen@redhat.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"johannes.berg@intel.com" <johannes.berg@intel.com>,
	"joe@perches.com" <joe@perches.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging:rtl8723au:ioctl_cfg80211:spaces required around '>'
Date: Sun, 14 Jun 2015 03:01:06 +0000
Message-ID: <20150614030059.GA6428@Tejas-asus> (sfid-20150614_051622_601178_804F05B3)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Joglekar Tejas <tjogleka@visteon.com>

This patch removes the error given by checkpatch.pl
" spaces required around that '>' "

Signed-off-by: Joglekar Tejas <tjogleka@visteon.com>
---
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
index bc95ce8..feb5961 100644
--- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
@@ -1041,7 +1041,7 @@ static u16 rtw_get_cur_max_rate(struct rtw_adapter *adapter)
 		while (pcur_bss->SupportedRates[i] != 0 &&
 		       pcur_bss->SupportedRates[i] != 0xFF) {
 			rate = pcur_bss->SupportedRates[i] & 0x7F;
-			if (rate>max_rate)
+			if (rate > max_rate)
 				max_rate = rate;
 			i++;
 		}
-- 
1.9.1
