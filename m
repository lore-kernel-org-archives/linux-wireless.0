Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:43196 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729891AbeGSGqL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 02:46:11 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 07/23] staging: wilc1000: rename enum SITESURVEY to use lowercase
Date: Thu, 19 Jul 2018 04:15:03 +0530
Message-ID: <1531953919-20804-8-git-send-email-ajay.kathat@microchip.com> (sfid-20180719_080459_388243_B6B14324)
In-Reply-To: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to have enum in lowercase as per linux coding style.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 drivers/staging/wilc1000/host_interface.h | 2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index cc64b14..a5c0ac5 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -635,7 +635,7 @@ static void handle_cfg_param(struct work_struct *work)
 		i++;
 	}
 	if (param->flag & SITE_SURVEY) {
-		enum SITESURVEY enabled = param->site_survey_enabled;
+		enum site_survey enabled = param->site_survey_enabled;
 
 		if (enabled < 3) {
 			wid_list[i].id = WID_SITE_SURVEY;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 64fc269..7f3e48c 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -113,7 +113,7 @@ struct cfg_param_attr {
 	u8 txop_prot_disabled;
 	u16 beacon_interval;
 	u16 dtim_period;
-	enum SITESURVEY site_survey_enabled;
+	enum site_survey site_survey_enabled;
 	u16 site_survey_scan_time;
 	u8 scan_source;
 	u16 active_scan_time;
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index af414d7..b82e149 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -138,7 +138,7 @@ enum AUTHTYPE {
 	IEEE8021		= 5
 };
 
-enum SITESURVEY {
+enum site_survey {
 	SITE_SURVEY_1CH		= 0,
 	SITE_SURVEY_ALL_CH	= 1,
 	SITE_SURVEY_OFF		= 2
-- 
2.7.4
