Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:12438 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab0AVAxO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 19:53:14 -0500
Received: by ey-out-2122.google.com with SMTP id 22so1855eye.5
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2010 16:53:13 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 0/5] b43: more N-PHY stuff
Date: Fri, 22 Jan 2010 01:53:11 +0100
Message-Id: <1264121596-9616-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, I hope to have patch submission fixed, please let me know if there
is anything wrong still.

Rafał Miłecki (5):
  b43: check band width
  b43: N-PHY: implement overriding RF control
  b43: N-PHY: add running samples
  b43: N-PHY: add setting power amplifier filters
  b43: N-PHY: add TX tone

 drivers/net/wireless/b43/main.c        |    6 +
 drivers/net/wireless/b43/phy_common.h  |    3 +
 drivers/net/wireless/b43/phy_n.c       |  253 ++++++++++++++++++++++++++++++--
 drivers/net/wireless/b43/tables_nphy.c |   61 ++++++++
 drivers/net/wireless/b43/tables_nphy.h |   22 +++
 5 files changed, 330 insertions(+), 15 deletions(-)

