Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:41612 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaJHDlv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 23:41:51 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 0/3] ath9k patches
Date: Wed,  8 Oct 2014 09:12:42 +0530
Message-Id: <1412739765-31679-1-git-send-email-sujith@msujith.org> (sfid-20141008_054204_372359_43B3544A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Fixes related to reset.

Sujith Manoharan (3):
  ath9k: Unify reset API
  ath9k: Set ATH_OP_HW_RESET before HW reset
  ath9k: Disable beacon tasklet during reset

 drivers/net/wireless/ath/ath9k/ath9k.h   |  3 +--
 drivers/net/wireless/ath/ath9k/channel.c |  2 +-
 drivers/net/wireless/ath/ath9k/main.c    | 26 +++++++++++++++++++++-----
 drivers/net/wireless/ath/ath9k/tx99.c    |  4 ++--
 4 files changed, 25 insertions(+), 10 deletions(-)

-- 
2.1.2

