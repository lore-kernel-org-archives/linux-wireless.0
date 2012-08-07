Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31792 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450Ab2HGBOg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 21:14:36 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20512.27555.477724.284749@gargle.gargle.HOWL> (sfid-20120807_031443_083005_D3EC3ADC)
Date: Tue, 7 Aug 2012 06:43:07 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC 00/14] ath9k RC cleanup
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches have been festering in my queue for some time now.
It's a work-in-progress and a little incomplete.

Please review !

Sujith

Sujith Manoharan (14):
  ath9k: Simplify rate table initialization
  ath9k: Cleanup RC init API
  ath9k: Cleanup ath_rc_setvalid_rates
  ath9k: Cleanup ath_rc_setvalid_htrates
  ath9k: Cleanup index retrieval routines
  ath9k: Change rateset calculation
  ath9k: Remove ath_rc_set_valid_rate_idx
  ath9k: Unify valid rate calculation routines
  ath9k: Do not set IEEE80211_TX_RC_USE_SHORT_PREAMBLE
  ath9k: Fix RTS/CTS rate selection
  ath9k: Bail out properly before calculating rate index
  ath9k: Cleanup TX status API
  ath9k: Remove MIMO-PS specific code
  ath9k: Trim rate table

 drivers/net/wireless/ath/ath9k/rc.c | 807 +++++++++++++++---------------------
 drivers/net/wireless/ath/ath9k/rc.h |   4 -
 2 files changed, 339 insertions(+), 472 deletions(-)

-- 
1.7.11.4

