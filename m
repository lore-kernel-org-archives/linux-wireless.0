Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48336 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbaDAOEU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2014 10:04:20 -0400
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Chen-Yu Tsai <wens@csie.org>, Rhyland Klein <rklein@nvidia.com>,
	Marc Dietrich <marvin24@gmx.de>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Alexandre Courbot <gnurou@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-tegra@vger.kernel.org
Subject: [PATCHv3 0/5] net: rfkill: gpio: cleanup and a few new acpi ids
Date: Tue,  1 Apr 2014 17:02:51 +0300
Message-Id: <1396360976-28657-1-git-send-email-heikki.krogerus@linux.intel.com> (sfid-20140401_160757_928637_A13C9BAB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I hope this one is OK with everyone.

Changes since v2:
- Instead of changing the driver to use only indexed gpios, just
  hard-coding the names.

Changes since v1:
- Removed the gpio entries from arch/arm/mach-tegra/board-paz00.c


Heikki Krogerus (5):
  ARM: tegra: remove obsolete gpio entries
  net: rfkill: gpio: remove unused and obsolete platform parameters
  net: rfkill: gpio: add ACPI ID for GPS module on Lenovo Miix2
  net: rfkill: gpio: add ACPI IDs for a Broadcom bluetooth chip
  net: rfkill: gpio: hard-code the gpio names

 arch/arm/mach-tegra/board-paz00.c |  4 +---
 include/linux/rfkill-gpio.h       | 10 ----------
 net/rfkill/rfkill-gpio.c          | 40 +++++++++------------------------------
 3 files changed, 10 insertions(+), 44 deletions(-)

-- 
1.9.1

