Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:34380 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753719AbdECOWk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 10:22:40 -0400
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sebastian Reichel <sre@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Subject: [PATCHv2 2/4] ARM: dts: omap4-droid4: Use wl1285 for wifi compatible
Date: Wed,  3 May 2017 16:22:24 +0200
Message-Id: <20170503142226.32380-3-sebastian.reichel@collabora.co.uk> (sfid-20170503_162254_982050_A4A3FFA1)
In-Reply-To: <20170503142226.32380-1-sebastian.reichel@collabora.co.uk>
References: <20170503142226.32380-1-sebastian.reichel@collabora.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Motorola Droid 4 uses a WL 1285C, so let's use correct
compatible value instead of relying on WL 1283 being very
similar.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
---
 arch/arm/boot/dts/omap4-droid4-xt894.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap4-droid4-xt894.dts b/arch/arm/boot/dts/omap4-droid4-xt894.dts
index 89eb607f4a9e..c09b51d6ccf7 100644
--- a/arch/arm/boot/dts/omap4-droid4-xt894.dts
+++ b/arch/arm/boot/dts/omap4-droid4-xt894.dts
@@ -301,7 +301,7 @@
 	#address-cells = <1>;
 	#size-cells = <0>;
 	wlcore: wlcore@2 {
-		compatible = "ti,wl1283";
+		compatible = "ti,wl1285";
 		reg = <2>;
 		interrupt-parent = <&gpio4>;
 		interrupts = <4 IRQ_TYPE_LEVEL_HIGH>; /* gpio100 */
-- 
2.11.0
