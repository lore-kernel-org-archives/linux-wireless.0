Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:53393 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab1ICS6f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Sep 2011 14:58:35 -0400
Received: by yie30 with SMTP id 30so2801493yie.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Sep 2011 11:58:34 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 0/3] Update copyrights, module info, a little LCN improvement
Date: Sat,  3 Sep 2011 21:01:00 +0200
Message-Id: <1315076463-11222-1-git-send-email-zajec5@gmail.com> (sfid-20110903_205839_511573_D6BBF3B3)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm adding my Copyrights to the files I've touched/created in 2010-2011.

Hope you'll accept adding myself as b43 author.

LCN patch almost finishes tables init for that family of cards.

Rafał Miłecki (3):
  b43: drop Copyright for not really copyrightable info
  b43: add my copyrights and myself as the module author
  b43: LCN-PHY: load TX gain table on init

 drivers/net/wireless/b43/bus.c            |    2 +
 drivers/net/wireless/b43/main.c           |    2 +
 drivers/net/wireless/b43/phy_ht.c         |    2 +
 drivers/net/wireless/b43/phy_lcn.c        |    2 +
 drivers/net/wireless/b43/phy_n.c          |    1 +
 drivers/net/wireless/b43/radio_2055.c     |    1 +
 drivers/net/wireless/b43/radio_2056.c     |    2 +
 drivers/net/wireless/b43/radio_2056.h     |   26 ----
 drivers/net/wireless/b43/radio_2059.c     |    2 +
 drivers/net/wireless/b43/tables_nphy.c    |    1 +
 drivers/net/wireless/b43/tables_phy_ht.c  |    2 +
 drivers/net/wireless/b43/tables_phy_lcn.c |  197 ++++++++++++++++++++++++++++-
 12 files changed, 211 insertions(+), 29 deletions(-)

-- 
1.7.3.4

