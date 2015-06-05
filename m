Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:33622 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422727AbbFEOBv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2015 10:01:51 -0400
Received: by pdjn11 with SMTP id n11so16312632pdj.0
        for <linux-wireless@vger.kernel.org>; Fri, 05 Jun 2015 07:01:51 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: ap420073@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] rtlwifi: rtl8192cu: debug message change "RTL8192CE" to "RTL8192CU"
Date: Fri,  5 Jun 2015 23:01:37 +0900
Message-Id: <1433512898-30137-2-git-send-email-ap420073@gmail.com> (sfid-20150605_160200_471143_57299792)
In-Reply-To: <1433512898-30137-1-git-send-email-ap420073@gmail.com>
References: <1433512898-30137-1-git-send-email-ap420073@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the rtlwifi/rtl8192cu, I change debug message "RTL8192CE" to
"RTL8192CU".

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
index 12f6d47..5534dad 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
@@ -162,7 +162,7 @@ bool _rtl92cu_phy_config_mac_with_headerfile(struct ieee80211_hw *hw)
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, "Read Rtl819XMACPHY_Array\n");
 	arraylength =  rtlphy->hwparam_tables[MAC_REG].length ;
 	ptrarray = rtlphy->hwparam_tables[MAC_REG].pdata;
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, "Img:RTL8192CEMAC_2T_ARRAY\n");
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, "Img:RTL8192CUMAC_2T_ARRAY\n");
 	for (i = 0; i < arraylength; i = i + 2)
 		rtl_write_byte(rtlpriv, ptrarray[i], (u8) ptrarray[i + 1]);
 	return true;
@@ -259,18 +259,18 @@ bool rtl92cu_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 		radiob_arraylen = rtlphy->hwparam_tables[RADIOB_2T].length;
 		radiob_array_table = rtlphy->hwparam_tables[RADIOB_2T].pdata;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "Radio_A:RTL8192CERADIOA_2TARRAY\n");
+			 "Radio_A:RTL8192CURADIOA_2TARRAY\n");
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "Radio_B:RTL8192CE_RADIOB_2TARRAY\n");
+			 "Radio_B:RTL8192CU_RADIOB_2TARRAY\n");
 	} else {
 		radioa_arraylen = rtlphy->hwparam_tables[RADIOA_1T].length;
 		radioa_array_table = rtlphy->hwparam_tables[RADIOA_1T].pdata;
 		radiob_arraylen = rtlphy->hwparam_tables[RADIOB_1T].length;
 		radiob_array_table = rtlphy->hwparam_tables[RADIOB_1T].pdata;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "Radio_A:RTL8192CE_RADIOA_1TARRAY\n");
+			 "Radio_A:RTL8192CU_RADIOA_1TARRAY\n");
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "Radio_B:RTL8192CE_RADIOB_1TARRAY\n");
+			 "Radio_B:RTL8192CU_RADIOB_1TARRAY\n");
 	}
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, "Radio No %x\n", rfpath);
 	switch (rfpath) {
-- 
2.1.4

