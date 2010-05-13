Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48065 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab0EMRdp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 13:33:45 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/2] ath9k: bb watchdog events for AR9003
Date: Thu, 13 May 2010 13:33:42 -0400
Message-Id: <1273772024-6994-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These two patches enable the baseband watchdog events for the
AR9003 family. One touches the hardware code, the other patch
enables this on the driver core.

Luis R. Rodriguez (2):
  ath9k_hw: add support for the AR9003 baseband watchdog
  ath9k: enable the baseband watchdog events for AR9003

 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    5 +
 drivers/net/wireless/ath/ath9k/ar9003_mac.h |    1 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |  119 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |   66 ++++++++--------
 drivers/net/wireless/ath/ath9k/debug.c      |    5 +
 drivers/net/wireless/ath/ath9k/debug.h      |    2 +
 drivers/net/wireless/ath/ath9k/hw.c         |    2 +
 drivers/net/wireless/ath/ath9k/hw.h         |    9 ++-
 drivers/net/wireless/ath/ath9k/main.c       |   10 ++-
 drivers/net/wireless/ath/ath9k/reg.h        |    1 +
 10 files changed, 185 insertions(+), 35 deletions(-)

