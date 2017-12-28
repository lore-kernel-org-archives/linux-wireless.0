Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:38730 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751220AbdL1THp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Dec 2017 14:07:45 -0500
Received: by mail-lf0-f67.google.com with SMTP id w196so28200739lff.5
        for <linux-wireless@vger.kernel.org>; Thu, 28 Dec 2017 11:07:44 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH 1/3] ath10k: fix spelling error
Date: Thu, 28 Dec 2017 20:06:43 +0100
Message-Id: <20171228190645.25773-2-erik.stromdahl@gmail.com> (sfid-20171228_200753_187175_8BEAEE79)
In-Reply-To: <20171228190645.25773-1-erik.stromdahl@gmail.com>
References: <20171228190645.25773-1-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index b0ed38c05bf8..c7b30ed9015d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2929,7 +2929,7 @@ struct wmi_ext_resource_config_10_4_cmd {
 	__le32 max_tdls_concurrent_buffer_sta;
 };
 
-/* strucutre describing host memory chunk. */
+/* structure describing host memory chunk. */
 struct host_memory_chunk {
 	/* id of the request that is passed up in service ready */
 	__le32 req_id;
-- 
2.15.1
