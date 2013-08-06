Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:57288 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752831Ab3HFBxb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 21:53:31 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/4] mwifiex: increase max supported pattern offset
Date: Mon, 5 Aug 2013 18:51:59 -0700
Message-ID: <1375753920-10100-3-git-send-email-bzhao@marvell.com> (sfid-20130806_035333_610316_371F2F6D)
In-Reply-To: <1375753920-10100-1-git-send-email-bzhao@marvell.com>
References: <1375753920-10100-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

The offset number is increased to accomodate requests from
user to match more fields in a Rx packet.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index c0dfc4d..12c6223 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -450,7 +450,7 @@ enum P2P_MODES {
 	(((event_cause) >> 24) & 0x00ff)
 
 #define MWIFIEX_MAX_PATTERN_LEN		20
-#define MWIFIEX_MAX_OFFSET_LEN		50
+#define MWIFIEX_MAX_OFFSET_LEN		100
 #define STACK_NBYTES			100
 #define TYPE_DNUM			1
 #define TYPE_BYTESEQ			2
-- 
1.8.2.3

