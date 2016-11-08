Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12128 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752172AbcKHPDi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Nov 2016 10:03:38 -0500
From: <c_traja@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <tamizhchelvam@codeaurora.org>
Subject: [PATCH 3/4] dt: bindings: add new dt entry for BTCOEX feature in qcom,ath10k.txt
Date: Tue, 8 Nov 2016 20:34:22 +0530
Message-ID: <1478617462-28188-1-git-send-email-c_traja@qti.qualcomm.com> (sfid-20161108_160341_059540_9F18B18E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <tamizhchelvam@codeaurora.org>

There two things done in this patch.

1) 'btcoex_support' flag for BTCOEX feature support by the hardware.
2) 'wlan_btcoex_gpio' is used to fill wlan priority pin number for
   BTCOEX priority feature support.

Signed-off-by: Tamizh chelvam <tamizhchelvam@codeaurora.org>
---
 .../bindings/net/wireless/qcom,ath10k.txt          |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index 74d7f0a..08150e2d 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -46,6 +46,10 @@ Optional properties:
 				 hw versions.
 - qcom,ath10k-pre-calibration-data : pre calibration data as an array,
 				     the length can vary between hw versions.
+- btcoex_support  : should contain eithr "0" or "1" to indicate btcoex
+		    support by the hardware.
+- btcoex_gpio_pin :  btcoex gpio pin number for the device which
+		     supports BTCOEX.
 
 Example (to supply the calibration data alone):
 
-- 
1.7.9.5
