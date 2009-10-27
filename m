Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39711 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770AbZJ0Q7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 12:59:33 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/5] ath9k_hw: name fixes and reset fix
Date: Tue, 27 Oct 2009 12:59:32 -0400
Message-Id: <1256662777-20469-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John here this series has the name fix plus two more fixes I made
yesterday to get ar9271 to reset the hw properly.

Luis R. Rodriguez (5):
  ath9k_hw: move mac name and rf name helpers to hw code
  ath9k_hw: distinguish single-chip solutions on initial probe print
  ath9k_hw: add AR9271 single chip name mapping
  ath9k_hw: correct AR_PHY_SPECTRAL_SCAN register offset
  ath9k_hw: remove bogus register write on ath9k_hw_9271_pa_cal()

 drivers/net/wireless/ath/ath9k/ahb.c   |   10 ++--
 drivers/net/wireless/ath/ath9k/calib.c |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c    |   89 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/hw.h    |    2 +
 drivers/net/wireless/ath/ath9k/main.c  |   58 ---------------------
 drivers/net/wireless/ath/ath9k/pci.c   |   10 ++--
 drivers/net/wireless/ath/ath9k/phy.h   |   16 +++++-
 7 files changed, 113 insertions(+), 74 deletions(-)

