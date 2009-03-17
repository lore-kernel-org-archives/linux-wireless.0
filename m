Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:50304 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbZCQDIP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 23:08:15 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [RFC][RFT][PATCH 0/5] ar9170: ar9170 driver
Date: Tue, 17 Mar 2009 04:08:12 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>, mcgrof@gmail.com,
	Alina Friedrichsen <x-alina@gmx.net>,
	Daniel White <daniel@whitehouse.id.au>, Joerg A <jal2@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903170408.12626.chunkeey@web.de> (sfid-20090317_040817_406962_85BB4BAF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes' ar9170 has been in development for a while.
However he is very busy pushing on the mac80211 stack...

I'll take a bite and try to help with ar9170 kernel inclusion.
before the fatal bit-rot claims a victim.

the diffstat:
 MAINTAINERS                          |    8
 drivers/net/wireless/Kconfig         |    1
 drivers/net/wireless/Makefile        |    1
 drivers/net/wireless/ar9170/Kconfig  |   23
 drivers/net/wireless/ar9170/Makefile |    6
 drivers/net/wireless/ar9170/ar9170.h |  177 ++++
 drivers/net/wireless/ar9170/cmd.c    |  118 ++
 drivers/net/wireless/ar9170/cmd.h    |   87 ++
 drivers/net/wireless/ar9170/eeprom.h |  179 ++++
 drivers/net/wireless/ar9170/hw.h     |  385 +++++++++
 drivers/net/wireless/ar9170/led.c    |  167 +++
 drivers/net/wireless/ar9170/mac.c    |  302 +++++++
 drivers/net/wireless/ar9170/main.c   | 1486 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ar9170/phy.c    | 1223 ++++++++++++++++++++++++++++
 drivers/net/wireless/ar9170/usb.c    |  754 +++++++++++++++++
 drivers/net/wireless/ar9170/usb.h    |   80 +
 16 files changed, 4997 insertions(+)

obvious fact: that's nearly 5000 lines of code...

I really hope that you guys have a few comments and tips , so we hit 5k ;-)

Please give me some feedback and mmmmooore patches!
And don't forget to update the copyright boilerplate!

Enjoy!
