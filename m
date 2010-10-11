Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61688 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab0JKBK7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 21:10:59 -0400
Received: by bwz15 with SMTP id 15so1403810bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Oct 2010 18:10:58 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 0/3] b43: N-PHY: Channel info cleaning
Date: Mon, 11 Oct 2010 03:11:00 +0200
Message-Id: <1286759463-32221-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I didn't get any NACK for my RFC, so there we go...

Two first patches contain changes I proposed in my single RFC plus one-line
change of setting channel in (to-be-dropped) radio_chanspec.

Third patch fixes logic mistake in decision about band change. By the way
it renames one variable to self-explaining.

Rafał Miłecki (3):
  b43: N-PHY: grab more info about new channel
  b43: N-PHY: store info about current channel's type
  b43: N-PHY: fix logic in band switching

 drivers/net/wireless/b43/phy_common.h |    4 +-
 drivers/net/wireless/b43/phy_n.c      |   74 +++++++++++++++++---------------
 drivers/net/wireless/b43/phy_n.h      |    1 -
 3 files changed, 42 insertions(+), 37 deletions(-)

