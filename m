Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:4914 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751065Ab0DKMbZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Apr 2010 08:31:25 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH v2 0/9] rt2x00: Align with vendor driver and add support for rt3070/rt3071/rt3090/rt3390.
Date: Sun, 11 Apr 2010 14:31:06 +0200
Message-Id: <1270989075-2267-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series aligns rt2x00 with the latest versions of the Ralink 
rt2860 / rt2870 / rt3070 / rt3090 drivers, and adds support for RT3070,
RT3071, RT3090, and RT3390 based devices.

The patches are relative to wireless-next-2.6, and can also be pulled
from:

	git://git.gwingerde.nl/rt2x00-next-2.6

v2: Handle comments received from Ivo, Julian and Felix.

Gertjan van Wingerde (9):
  rt2x00: Let RF chipset decide the RF channel switch method to use in rt2800.
  rt2x00: Update rt2800 register definitions towards latest definitions.
  rt2x00: Align RT chipset definitions with vendor driver.
  rt2x00: Refactor rt2800 version constants.
  rt2x00: Align rt2800 register initialization with vendor driver.
  rt2x00: Finish rt3070 support in rt2800 register initialization.
  rt2x00: Add rt3071 support in rt2800 register initialization.
  rt2x00: Add rt3090 support in rt2800 register initialization.
  rt2x00: Add rt3390 support in rt2800 register initialization.

 drivers/net/wireless/rt2x00/rt2800.h    |  108 +++++++-
 drivers/net/wireless/rt2x00/rt2800lib.c |  464 ++++++++++++++++++++++---------
 drivers/net/wireless/rt2x00/rt2800pci.c |   13 -
 drivers/net/wireless/rt2x00/rt2x00.h    |   29 ++-
 4 files changed, 458 insertions(+), 156 deletions(-)

