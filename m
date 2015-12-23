Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from softlayer.compulab.co.il ([50.23.254.55]:48211 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810AbbLWIfx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2015 03:35:53 -0500
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
Subject: [PATCH 0/3] wlcore/wl12xx: spi: add wifi support to cm-t335
Date: Wed, 23 Dec 2015 10:35:41 +0200
Message-Id: <1450859744-9948-1-git-send-email-uri.mashiach@compulab.co.il> (sfid-20151223_093613_220877_C0A02336)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add DT support for WLS1271 SPI driver.
Fix oops by adding a power callback.

Uri Mashiach (3):
  wlcore/wl12xx: spi: fix NULL pointer dereference (Oops)
  wlcore/wl12xx: spi: add device tree support
  wlcore/wl12xx: spi: add wifi support to cm-t335

 .../bindings/net/wireless/ti,wlcore,spi.txt        |  35 +++++++
 arch/arm/boot/dts/am335x-cm-t335.dts               |  58 +++++++++++-
 drivers/net/wireless/ti/wlcore/spi.c               | 104 +++++++++++++++++++--
 3 files changed, 189 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt

-- 
2.5.0

