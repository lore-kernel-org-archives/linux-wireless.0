Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35962 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab0CKXXz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 18:23:55 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: stable@kernel.org
Cc: linville@tuxdriver.com, mb@bu3sch.de, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/2] ath5k: few AP fixes for 2.6.32
Date: Thu, 11 Mar 2010 18:23:47 -0500
Message-Id: <1268349829-3195-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches were already merged into the latest 2.6.33.y,
however they are not yet in the latest 2.6.32.y, they are
reported to make ath5k AP support rock solid by a few people.

For your conveinience I have also put these patches up here:

http://kernel.org/pub/linux/kernel/people/mcgrof/patches/ath5k/2010-03/ath5k-ap-fixes-32/

Bob Copeland (2):
  ath5k: dont use external sleep clock in AP mode
  ath5k: fix setup for CAB queue

 drivers/net/wireless/ath/ath5k/ath5k.h |    2 +-
 drivers/net/wireless/ath/ath5k/base.c  |   22 +++++++++++++++++++---
 drivers/net/wireless/ath/ath5k/qcu.c   |    5 +++--
 drivers/net/wireless/ath/ath5k/reset.c |    5 +++--
 4 files changed, 26 insertions(+), 8 deletions(-)

