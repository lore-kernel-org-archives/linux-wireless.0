Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from softlayer.compulab.co.il ([50.23.254.55]:41407 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbbL1MCh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Dec 2015 07:02:37 -0500
From: Uri Mashiach <uri.mashiach@compulab.co.il>
To: Kalle Valo <kvalo@codeaurora.org>,
	Rob Herring <robh+dt@kernel.org>,
	Tony Lindgren <tony@atomide.com>
Cc: Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, bcousson@baylibre.com,
	Igor Grinberg <grinberg@compulab.co.il>,
	Eliad Peller <eliad@wizery.com>, devicetree@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	Uri Mashiach <uri.mashiach@compulab.co.il>
Subject: [PATCH v3 0/3] wlcore/wl12xx: spi: add wifi support to cm-t335
Date: Mon, 28 Dec 2015 14:02:16 +0200
Message-Id: <1451304139-10899-1-git-send-email-uri.mashiach@compulab.co.il> (sfid-20151228_130242_011728_3328F4CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add DT support for WLS1271 SPI driver.
Add power operation function to the WLS1271 SPI driver.

Uri Mashiach (3):
  wlcore/wl12xx: spi: add power operation function
  wlcore/wl12xx: spi: add device tree support
  wlcore/wl12xx: spi: add wifi support to cm-t335

 .../bindings/net/wireless/ti,wlcore,spi.txt        | 34 +++++++++
 arch/arm/boot/dts/am335x-cm-t335.dts               | 54 ++++++++++++++
 drivers/net/wireless/ti/wlcore/Kconfig             |  2 +-
 drivers/net/wireless/ti/wlcore/spi.c               | 84 ++++++++++++++++++++--
 4 files changed, 169 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt

-- 
2.5.0

