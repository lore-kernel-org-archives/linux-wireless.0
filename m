Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57772 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860Ab0CKV4E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 16:56:04 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: stable@kernel.org
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/2] ath9k: few stable interrupt fixes
Date: Thu, 11 Mar 2010 16:55:56 -0500
Message-Id: <1268344558-13835-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a few stable IRQ fixes for ath9k which have already
been merged upstream. We forgot to add the stable tag on them
so sending these out manually.

The patches in this series apply to the latest 2.6.33.y but for
your convenience I have also backported the patches to the latest
2.6.32.y kernel.

The 2.6.33.y patches can be found here:

http://kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2010-03/33-fixes/01-ath9k-irq/

The 2.6.32.y patches can be found here:

http://kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2010-03/32-fixes/01-ath9k-irq/

Senthil Balasubramanian (2):
  ath9k: Enable TIM timer interrupt only when needed.
  ath9k: configure the beacon only if the STA is associated

 drivers/net/wireless/ath/ath9k/ath9k.h  |    1 +
 drivers/net/wireless/ath/ath9k/beacon.c |    7 +++++++
 drivers/net/wireless/ath/ath9k/main.c   |   24 ++++++++++++++----------
 drivers/net/wireless/ath/ath9k/xmit.c   |    7 +++----
 4 files changed, 25 insertions(+), 14 deletions(-)

