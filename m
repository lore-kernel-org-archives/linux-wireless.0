Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:36660 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdBBKTy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Feb 2017 05:19:54 -0500
Received: by mail-lf0-f49.google.com with SMTP id z134so5921479lff.3
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2017 02:19:54 -0800 (PST)
From: =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?=
        <amadeusz.slawinski@tieto.com>
To: ath10k@lists.infradead.org, Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?=
        <amadeusz.slawinski@tieto.com>
Subject: [PATCH 3/3] ath10k: fix comment
Date: Thu,  2 Feb 2017 11:19:33 +0100
Message-Id: <1486030773-30600-3-git-send-email-amadeusz.slawinski@tieto.com> (sfid-20170202_112050_068120_41407625)
In-Reply-To: <1486030773-30600-1-git-send-email-amadeusz.slawinski@tieto.com>
References: <1486030773-30600-1-git-send-email-amadeusz.slawinski@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I wanted to take a look and it's apparently in other header

Signed-off-by: Amadeusz Sławiński <amadeusz.slawinski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 5d3dff9..bf8dcbe 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -75,7 +75,7 @@ struct wmi_cmd_hdr {
 
 /*
  * There is no signed version of __le32, so for a temporary solution come
- * up with our own version. The idea is from fs/ntfs/types.h.
+ * up with our own version. The idea is from fs/ntfs/endian.h.
  *
  * Use a_ prefix so that it doesn't conflict if we get proper support to
  * linux/types.h.
-- 
1.9.1
