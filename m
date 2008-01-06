Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:48847 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbYAFRDh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2008 12:03:37 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: b43 will need a firmware upgrade soon
Date: Sun, 6 Jan 2008 18:02:38 +0100
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Message-Id: <200801061802.38297.mb@bu3sch.de> (sfid-20080106_170347_696227_7E8FD0D3)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The b43 driver will need an incompatible firmware upgrade, soon.
I'm probably going to do this in 2.6.25 or 2.6.26.

The update will require people to download and extract updated
officially supported firmware. The firmware will be linked to
from the usual place at linuxwireless.org.
The driver will print a verbose error message when it detects
too old firmware and abort initialization.

This is needed in order to add support for new devices (N-PHY).
Broadcom changed the ABI of the firmware, so we are forced to also
change the ABI of the driver.

I'm very sorry for the inconvenience.

-- 
Greetings Michael.
