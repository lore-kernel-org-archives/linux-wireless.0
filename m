Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:34693
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754912Ab2LGKCl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 05:02:41 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 0/8] PAPRD for ath9k
Date: Fri,  7 Dec 2012 15:31:53 +0530
Message-Id: <1354874521-4138-1-git-send-email-sujith@msujith.org> (sfid-20121207_110246_021382_E0CAF86C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This patch series enables PAPRD functionality for AR9485,
AR9462 and AR9565. Please review !

Sujith Manoharan (8):
  ath9k_hw: Fix PAPRD registers for AR9485
  ath9k_hw: Fix PAPRD training
  ath9k: Add a few debug messages for PAPRD
  ath9k: Fix redundant PS wrappers
  ath9k_hw: Various trivial fixes for PAPRD
  ath9k_hw: Fix PAPRD retraining for AR9485
  ath9k_hw: Calculate the correct training power for PAPRD
  ath9k_hw: Enable PAPRD for AR9485, AR9462 and AR9565

 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 49 +++++++++------
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c  | 87 +++++++++++++++++++-------
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    | 29 +++++----
 drivers/net/wireless/ath/ath9k/hw.c            | 11 ++++
 drivers/net/wireless/ath/ath9k/hw.h            |  4 +-
 drivers/net/wireless/ath/ath9k/link.c          | 22 ++++---
 6 files changed, 137 insertions(+), 65 deletions(-)

-- 
1.8.0.1

