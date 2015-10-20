Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:33084 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbbJTGqV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 02:46:21 -0400
Received: by lffv3 with SMTP id v3so712098lff.0
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2015 23:46:20 -0700 (PDT)
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: Jes.Sorensen@redhat.com
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
	Jakub Sitnicki <jsitnicki@gmail.com>
Subject: [RFC 05/16] rtl8xxxu: Unbreak a user-visible string
Date: Tue, 20 Oct 2015 08:45:35 +0200
Message-Id: <1445323546-12807-6-git-send-email-jsitnicki@gmail.com> (sfid-20151020_084629_254702_D931AF3C)
In-Reply-To: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index cfb18db..e892fde 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2002,8 +2002,8 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
 		/* We have 8 bits to indicate validity */
 		map_addr = offset * 8;
 		if (map_addr >= EFUSE_MAP_LEN_8723A) {
-			dev_warn(dev, "%s: Illegal map_addr (%04x), "
-				 "efuse corrupt!\n",
+			dev_warn(dev,
+				 "%s: Illegal map_addr (%04x), efuse corrupt!\n",
 				 __func__, map_addr);
 			ret = -EINVAL;
 			goto exit;
-- 
2.1.0

