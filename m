Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:58628 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaJAKHu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 06:07:50 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@qca.qualcomm.com
Subject: [RFC 0/5] ath9k patches
Date: Wed,  1 Oct 2014 15:38:28 +0530
Message-Id: <1412158113-22913-1-git-send-email-sujith@msujith.org> (sfid-20141001_120753_276645_B84F538B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

MCC fixes. Please review.

Sujith Manoharan (5):
  ath9k: Fix queue handling in flush()
  ath9k: Pass context to ath9k_chanctx_wake_queues()
  ath9k: Add ath9k_chanctx_stop_queues()
  ath9k: Fix queue handling for channel contexts
  ath9k: Fix flushing in MCC mode

 drivers/net/wireless/ath/ath9k/ath9k.h   | 10 ++++++--
 drivers/net/wireless/ath/ath9k/channel.c | 41 +++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath9k/main.c    | 12 +---------
 3 files changed, 47 insertions(+), 16 deletions(-)

-- 
2.1.1

