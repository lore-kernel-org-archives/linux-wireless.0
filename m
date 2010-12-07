Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37488 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab0LGU4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 15:56:35 -0500
Received: by wyb28 with SMTP id 28so336422wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 12:56:34 -0800 (PST)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 0/4] Make N-PHY support experimental
Date: Tue,  7 Dec 2010 21:55:56 +0100
Message-Id: <1291755360-21570-1-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Finally, thanks for Larry and Francesco I got b43 working with BCM4328 chipset!

It's not perfectly stable yet, but scanning and associating to open network
works! It has to be tested, improved, there are some PHY errors from time to
time, but generally it works :)

Rafał Miłecki (4):
  b43: N-PHY: silence warnings
  b43: set TMS to work with current band width for N-PHY
  b43: fix split of N-PHY devices into supported and not (based on PHY
    rev)
  b43: rename config option for N-PHY, drop BROKEN

 drivers/net/wireless/b43/Kconfig      |   13 +++++++------
 drivers/net/wireless/b43/Makefile     |    8 ++++----
 drivers/net/wireless/b43/main.c       |   12 +++++++++---
 drivers/net/wireless/b43/phy_common.c |    9 ++++++++-
 drivers/net/wireless/b43/phy_common.h |    2 ++
 drivers/net/wireless/b43/phy_n.c      |   16 ++++++----------
 6 files changed, 36 insertions(+), 24 deletions(-)

