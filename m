Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41061 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab0DTW2h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 18:28:37 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/2] ath9k_hw: few initval cosmetic changes
Date: Tue, 20 Apr 2010 18:28:34 -0400
Message-Id: <1271802516-15195-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just a few cosmetic changes to the initvals. Using the checksum checker
I confirm the values are still intact :)

Luis R. Rodriguez (2):
  ath9k_hw: make two initvals consto for the AR9001 family
  ath9k_hw: make all AR9002 initvals use u32

 drivers/net/wireless/ath/ath9k/ar9001_initvals.h |    4 +-
 drivers/net/wireless/ath/ath9k/ar9002_initvals.h |   68 +++++++++++-----------
 2 files changed, 36 insertions(+), 36 deletions(-)

