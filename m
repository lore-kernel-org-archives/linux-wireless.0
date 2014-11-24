Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:58050 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaKXCgB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Nov 2014 21:36:01 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] ath10k patches
Date: Mon, 24 Nov 2014 08:07:34 +0530
Message-Id: <1416796657-24657-1-git-send-email-sujith@msujith.org> (sfid-20141124_033618_233971_00ED4527)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Fixes for WEP.

Sujith Manoharan (3):
  ath10k: Fix shared WEP
  ath10k: Fix locking for WEP keys
  ath10k: Fix bug reported by lockdep

 drivers/net/wireless/ath/ath10k/mac.c | 31 +++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/mac.h |  2 ++
 drivers/net/wireless/ath/ath10k/wmi.c | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+), 2 deletions(-)

-- 
2.1.3

