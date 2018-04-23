Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:16615 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932107AbeDWQfw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 12:35:52 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [RESEND 19/33] staging: wilc1000: fix line over 80 chars in change_station()
Date: Mon, 23 Apr 2018 22:03:21 +0530
Message-ID: <1524501215-4963-20-git-send-email-ajay.kathat@microchip.com> (sfid-20180423_183601_061905_432642B0)
In-Reply-To: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
References: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'line over 80 chars' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 5bd294d..1540511 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1154,10 +1154,10 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 		wilc_get_statistics(vif, &stats);
 
 		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL) |
-						BIT(NL80211_STA_INFO_RX_PACKETS) |
-						BIT(NL80211_STA_INFO_TX_PACKETS) |
-						BIT(NL80211_STA_INFO_TX_FAILED) |
-						BIT(NL80211_STA_INFO_TX_BITRATE);
+				 BIT(NL80211_STA_INFO_RX_PACKETS) |
+				 BIT(NL80211_STA_INFO_TX_PACKETS) |
+				 BIT(NL80211_STA_INFO_TX_FAILED) |
+				 BIT(NL80211_STA_INFO_TX_BITRATE);
 
 		sinfo->signal = stats.rssi;
 		sinfo->rx_packets = stats.rx_cnt;
-- 
2.7.4
