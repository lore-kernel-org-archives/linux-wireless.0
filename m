Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from softlayer.compulab.co.il ([50.23.254.55]:58141 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738AbbL3Nf5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 08:35:57 -0500
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
Subject: [PATCH v4 0/3] wlcore/wl12xx: spi: add wifi support to cm-t335
Date: Wed, 30 Dec 2015 15:35:30 +0200
Message-Id: <1451482533-8624-1-git-send-email-uri.mashiach@compulab.co.il> (sfid-20151230_143608_762702_082F841E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add DT support for WLS1271 SPI driver.
Add power operation function to the WLS1271 SPI driver.

Uri Mashiach (3):
  wlcore/wl12xx: spi: add power operation function
  wlcore/wl12xx: spi: add device tree support
  wlcore/wl12xx: spi: add wifi support to cm-t335

 .../bindings/net/wireless/ti,wlcore,spi.txt        | 36 +++++++++
 arch/arm/boot/dts/am335x-cm-t335.dts               | 55 ++++++++++++++
 drivers/net/wireless/ti/wlcore/Kconfig             |  2 +-
 drivers/net/wireless/ti/wlcore/spi.c               | 86 +++++++++++++++++++++-
 4 files changed, 174 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt

-- 
2.5.0

