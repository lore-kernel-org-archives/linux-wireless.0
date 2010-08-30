Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50517 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab0H3X0e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 19:26:34 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/2] ath9k_hw: couple of fixes for CTL index reading
Date: Mon, 30 Aug 2010 19:26:31 -0400
Message-Id: <1283210793-14240-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are two fixes for CTL index reading for regulatory purposes.
The first one only applies to 2.6.36+, the other one is intended to
go down to 2.6.27 when ath9k first got added upstream.

You can find the respective backports of each patch for each
respective kernel here:

http://kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2010/08/

Luis R. Rodriguez (2):
  ath9k_hw: Fix EEPROM uncompress block reading on AR9003
  ath9k_hw: fix parsing of HT40 5 GHz CTLs

 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom.h        |    2 +-
 drivers/net/wireless/ath/regd.h                |    1 -
 3 files changed, 2 insertions(+), 3 deletions(-)

