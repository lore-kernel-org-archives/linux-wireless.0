Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35260 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab0EMBPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 21:15:08 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/2] ath9k: Add AR9003 2.2 support
Date: Wed, 12 May 2010 21:15:04 -0400
Message-Id: <1273713306-13789-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These two patches address AR9300 2.2 support, the second
one just renames the 2.0 initvals file.

Luis R. Rodriguez (2):
  ath9k_hw: add support for the AR9003 2.2
  ath9k_hw: rename the ar9003_initvals.h to ar9003_2p0_initvals.h

 .../{ar9003_initvals.h => ar9003_2p0_initvals.h}   |    6 +-
 .../{ar9003_initvals.h => ar9003_2p2_initvals.h}   |  185 ++++++++++----------
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |  163 +++++++++++++++---
 3 files changed, 233 insertions(+), 121 deletions(-)
 copy drivers/net/wireless/ath/ath9k/{ar9003_initvals.h => ar9003_2p0_initvals.h} (99%)
 rename drivers/net/wireless/ath/ath9k/{ar9003_initvals.h => ar9003_2p2_initvals.h} (91%)

