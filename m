Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:35480 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab3GLEDc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jul 2013 00:03:32 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/6] initval patches
Date: Fri, 12 Jul 2013 09:30:07 +0530
Message-Id: <1373601613-31616-1-git-send-email-sujith@msujith.org> (sfid-20130712_060348_878230_B2C2D488)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This is a resend of the pending initval patches, rebased over
master.

Sujith Manoharan (6):
  initvals: Update inivals for AR9462 2.0
  initvals: Add 5g-XLNA table for AR9462
  initvals: Add ar9462_2p0_5g_xlna_only_rxgain table
  initvals: Add rxgain tables for AR9462
  initvals: Add support for AR9462 2.1
  initvals: Add mix ob/db tx gain table for AR9462 2.0

 tools/initvals/Makefile              |    2 +
 tools/initvals/ar9462_2p0_initvals.h |  345 ++++++-
 tools/initvals/ar9462_2p1_initvals.h | 1774 ++++++++++++++++++++++++++++++++++
 tools/initvals/checksums.txt         |   28 +-
 tools/initvals/initvals.c            |   61 ++
 5 files changed, 2208 insertions(+), 2 deletions(-)
 create mode 100644 tools/initvals/ar9462_2p1_initvals.h

-- 
1.8.3.2

