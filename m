Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:53786 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab3G3R15 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 13:27:57 -0400
From: Luciano Coelho <coelho@ti.com>
To: <tony@atomide.com>, <linux-omap@vger.kernel.org>
CC: <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>, <coelho@ti.com>,
	<luca@coelho.fi>, <balbi@ti.com>
Subject: [PATCH 0/4] ARM: dts: add WiLink support to panda and omap4-sdp
Date: Tue, 30 Jul 2013 20:27:24 +0300
Message-ID: <1375205248-25708-1-git-send-email-coelho@ti.com> (sfid-20130730_192806_706149_0AA9DA75)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

These patches add the necessary DT configuration to use the WLAN part
of WiLink on OMAP4 Pandaboard and on OMAP4-SDP (including Blaze).

I've tested these changes on Panda and it works fine.  But I couldn't
test the OMAP4 SDP changes properly on 3.11-rc3 because I'm having
problems with clocks and SDIO stuff.  So it's pretty much just
compiled tested.  I've tried this (without the new clock definition
stuff) on Blaze with 3.10 and it was working, though.

Please take a look and let me know what you think.

Luca.


Luciano Coelho (4):
  ARM: dts: omap4-panda: add MMC5 (WiLink WLAN) configuration
  arm: dts: omap4-panda-common: add WiLink6 device tree nodes
  ARM: dts: omap4-sdp: add MMC5 (WiLink WLAN) configuration
  arm: dts: omap4-sdp: add WiLink7 device tree node

 arch/arm/boot/dts/omap4-panda-common.dtsi | 45 +++++++++++++++++++++++++++-
 arch/arm/boot/dts/omap4-sdp.dts           | 49 +++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+), 1 deletion(-)

-- 
1.8.3.2

