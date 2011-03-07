Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64195 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab1CGCOa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 21:14:30 -0500
Received: by gyh20 with SMTP id 20so1494575gyh.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 18:14:30 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19828.16253.660303.551908@gargle.gargle.HOWL>
Date: Mon, 7 Mar 2011 07:44:21 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC 16/34] ath9k_htc: Remove unused WMI_WLAN_TXCOMP_EVENTID
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/wmi.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index 7896de4..07595f2 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -74,7 +74,6 @@ enum wmi_event_id {
 	WMI_FATAL_EVENTID,
 	WMI_TXTO_EVENTID,
 	WMI_BMISS_EVENTID,
-	WMI_WLAN_TXCOMP_EVENTID,
 	WMI_DELBA_EVENTID,
 	WMI_TXRATE_EVENTID,
 };
-- 
1.7.4.1

