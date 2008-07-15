Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:28283 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756258AbYGOMaB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 08:30:01 -0400
From: Bruno Randolf <br1@einfach.org>
Subject: [PATCH 0/3] iwlwifi: use generic radiotap headers
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	tomas.winkler@intel.com
Date: Tue, 15 Jul 2008 14:29:53 +0200
Message-ID: <20080715122806.10919.4335.stgit@void> (sfid-20080715_143037_501145_160892DA)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rebased against current tree...

---

Bruno Randolf (3):
      iwlwifi: use generic mac80211 radiotap headers
      mac80211: radiotap: assume modulation from rates
      mac80211: add rx status flag for short preamble


 drivers/net/wireless/iwlwifi/iwl-3945.c     |  104 +---------------------
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 
 drivers/net/wireless/iwlwifi/iwl-rx.c       |  129 ++++-----------------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 
 include/net/mac80211.h                      |    2 
 net/mac80211/rx.c                           |    7 +
 8 files changed, 35 insertions(+), 213 deletions(-)

