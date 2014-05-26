Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbaEZHtL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 03:49:11 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linus Walleij <linus.walleij@linaro.org>,
	Chris Ball <chris@printf.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
	linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 10/11] ARM: dts: sun7i: Add #interrupt-cells to pinctrl node
Date: Mon, 26 May 2014 09:48:05 +0200
Message-Id: <1401090486-4414-11-git-send-email-hdegoede@redhat.com> (sfid-20140526_095026_320927_29732F7F)
In-Reply-To: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chen-Yu Tsai <wens@csie.org>

The pinctrl device is also an interrupt controller for external
interrupts. Add the missing #interrupt-cells property.

Also remove the unused #address-cells property.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 arch/arm/boot/dts/sun7i-a20.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index b82642c..19b1ced 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -594,7 +594,7 @@
 			clocks = <&apb0_gates 5>;
 			gpio-controller;
 			interrupt-controller;
-			#address-cells = <1>;
+			#interrupt-cells = <2>;
 			#size-cells = <0>;
 			#gpio-cells = <3>;
 
-- 
1.9.3

