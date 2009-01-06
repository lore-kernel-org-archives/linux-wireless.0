Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:6282 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbZAFIvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 03:51:03 -0500
Received: by ey-out-2122.google.com with SMTP id 22so905204eye.37
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 00:51:01 -0800 (PST)
Message-ID: <eb3ff54b0901060051u19925521k6b5e7b39b4293f64@mail.gmail.com> (sfid-20090106_095108_837071_E7374095)
Date: Tue, 6 Jan 2009 10:51:01 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH 3/6] mac80211: remove an unused definition (MAX_STA_COUNT) in sta_info.h.
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes an unused definition of MAX_STA_COUNT in sta_info.h.


(wireless-testing).

Signed-off-by: Rami Rosen <ramirose@gmail.com>

diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index dc2606d..b956a55 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -383,8 +383,6 @@ static inline u32 get_sta_flags(struct sta_info *sta)
 }


-/* Maximum number of concurrently registered stations */
-#define MAX_STA_COUNT 2007

 #define STA_HASH_SIZE 256
 #define STA_HASH(sta) (sta[5])
