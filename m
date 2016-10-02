Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36745 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751967AbcJBWvI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Oct 2016 18:51:08 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, frowand.list@gmail.com,
        devicetree@vger.kernel.org, nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        ath9k-devel@lists.ath9k.org, kvalo@codeaurora.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [RFC 1/3] Documentation: dt-bindings: add IEEE 802.11 binding documentation
Date: Mon,  3 Oct 2016 00:50:57 +0200
Message-Id: <20161002225059.16757-2-martin.blumenstingl@googlemail.com> (sfid-20161003_005111_474012_EB11EEF7)
In-Reply-To: <20161002225059.16757-1-martin.blumenstingl@googlemail.com>
References: <20161002225059.16757-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds the documentation for the generic IEEE 802.111 binding, which
currently allows enabling and disabling the 2.4GHz and 5GHz band.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 Documentation/devicetree/bindings/net/wireless/ieee80211.txt | 12 ++++++++++++
 1 file changed, 12 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ieee80211.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/ieee80211.txt b/Documentation/devicetree/bindings/net/wireless/ieee80211.txt
new file mode 100644
index 0000000..41fab97
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/ieee80211.txt
@@ -0,0 +1,12 @@
+The following properties are common to the IEEE 802.11 controllers:
+
+- enable-ieee80211-2ghz: indicates that the 2.4GHz frequency band should be
+  enabled for this device. This must not be used together with the
+  "disable-ieee80211-2ghz" at the same time.
+- enable-ieee80211-5ghz: indicates that the 5GHz frequency band should be
+  enabled for this device. This must not be used together with the
+  "disable-ieee80211-5ghz" at the same time.
+- disable-ieee80211-2ghz: indicates that the 2.4GHz frequency band should be
+  disabled for this device.
+- disable-ieee80211-5ghz: indicates that the 5GHz frequency band should be
+  disabled for this device
-- 
2.10.0
