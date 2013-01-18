Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3192 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab3AROgZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 09:36:25 -0500
Message-ID: <50F95D45.6060601@broadcom.com> (sfid-20130118_153628_711652_2F6686F1)
Date: Fri, 18 Jan 2013 15:33:41 +0100
From: "Piotr Haber" <phaber@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>,
	"Rafal Milecki" <zajec5@gmail.com>
cc: linux-wireless@vger.kernel.org
Subject: bcma: trouble with gpio
Content-Type: text/plain;
 charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I turned GPIO support in bcma (CONFIG_BCMA_DRIVER_GPIO)
and get this in log:

bcma: bus0: Found chip with id 0xA8D8, rev 0x01 and package 0x0A
bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x22, class 0x0)
bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x17, class 0x0)
bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x0F, class 0x0)
bcma: bus0: Found rev 6 PMU (capabilities 0x108C2606)
bcma: bus0: SPROM offset 0x830
bcma: bus0: PMU resource config unknown or not needed for device 0xA8D8
gpiochip_add: gpios -1..14 (bcma_gpio) failed to register
bcma: bus0: Error registering GPIO driver: -28
bcma: bus0: Bus registered
bcma: bus1: Found chip with id 0x4313, rev 0x01 and package 0x08
bcma: bus1: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x24, class 0x0)
bcma: bus1: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x18, class 0x0)
bcma: bus1: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x11, class 0x0)
bcma: bus1: Found rev 8 PMU (capabilities 0x084C3008)
bcma: bus1: SPROM offset 0x830
gpiochip_add: gpios -1..14 (bcma_gpio) failed to register
bcma: bus1: Error registering GPIO driver: -28
bcma: bus1: Bus registered
bcma: bus2: Found chip with id 0x4313, rev 0x01 and package 0x08
bcma: bus2: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x24, class 0x0)
bcma: bus2: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x18, class 0x0)
bcma: bus2: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x11, class 0x0)
bcma: bus2: Found rev 8 PMU (capabilities 0x084C3008)
bcma: bus2: SPROM offset 0x830
gpiochip_add: gpios -1..14 (bcma_gpio) failed to register
bcma: bus2: Error registering GPIO driver: -28
bcma: bus2: Bus registered

does that mean that gpio is not usable?
what might be the problem?

Kind regards
Piotr

