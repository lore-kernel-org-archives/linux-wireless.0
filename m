Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:39806 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaJBBCm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 21:02:42 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 00/10] ath9k patches
Date: Thu,  2 Oct 2014 06:33:10 +0530
Message-Id: <1412211800-24344-1-git-send-email-sujith@msujith.org> (sfid-20141002_030246_003246_2170E7AC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Pending MCC fixes, rebased over -rc7.

Sujith Manoharan (10):
  ath: Add support for tracing
  ath9k: Print RoC expiration
  ath9k: Check pending frames properly
  ath9k: Fix pending frame check
  ath9k: Remove duplicate code
  ath9k: Fix queue handling in flush()
  ath9k: Pass context to ath9k_chanctx_wake_queues()
  ath9k: Add ath9k_chanctx_stop_queues()
  ath9k: Fix queue handling for channel contexts
  ath9k: Fix flushing in MCC mode

 drivers/net/wireless/ath/Kconfig         |  8 ++++
 drivers/net/wireless/ath/Makefile        |  4 ++
 drivers/net/wireless/ath/ath.h           |  1 +
 drivers/net/wireless/ath/ath9k/ath9k.h   | 10 ++++-
 drivers/net/wireless/ath/ath9k/channel.c | 48 +++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/main.c    | 30 +++-----------
 drivers/net/wireless/ath/main.c          |  3 ++
 drivers/net/wireless/ath/trace.c         | 20 +++++++++
 drivers/net/wireless/ath/trace.h         | 71 ++++++++++++++++++++++++++++++++
 9 files changed, 166 insertions(+), 29 deletions(-)
 create mode 100644 drivers/net/wireless/ath/trace.c
 create mode 100644 drivers/net/wireless/ath/trace.h

-- 
2.1.1

