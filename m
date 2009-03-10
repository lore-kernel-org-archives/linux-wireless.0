Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33831 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZCJCJp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 22:09:45 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/2] ath9k: cleanups
Date: Mon,  9 Mar 2009 22:09:40 -0400
Message-Id: <1236650982-11520-1-git-send-email-lrodriguez@atheros.com> (sfid-20090310_032926_541159_D2FD3AAA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just a couple of ath9k cleanups. One is a candidate for stable.

Luis R. Rodriguez (2):
  ath9k: downgrade xmit queue full message to xmit debug
  ath9k: make few eeprom and calib items static

 drivers/net/wireless/ath9k/calib.c  |    2 +-
 drivers/net/wireless/ath9k/eeprom.c |    8 ++++----
 drivers/net/wireless/ath9k/xmit.c   |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

