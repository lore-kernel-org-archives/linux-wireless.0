Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:48992 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751362Ab0G0Jr6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 05:47:58 -0400
Received: from vs3005.wh2.ocn.ne.jp (125.206.180.233)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-074444074
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jul 2010 18:47:56 +0900 (JST)
Subject: [PATCH v4 0/3] Antenna configuration
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Date: Tue, 27 Jul 2010 18:47:54 +0900
Message-ID: <20100727094732.27186.30900.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry for the long delay in following this up.

This is version 4 of my tries to some antenna configuration interface accepted - now using get/set thru the wiphy as Johannes has suggested.

Please see the first patch for a longer description.

bruno
---

Bruno Randolf (3):
      cfg80211: Add nl80211 antenna configuration
      mac80211: Add antenna configuration
      ath5k: Add support for antenna configuration


 drivers/net/wireless/ath/ath5k/base.c |   34 ++++++++++++++++++++++
 include/linux/nl80211.h               |   17 +++++++++++
 include/net/cfg80211.h                |    3 ++
 include/net/mac80211.h                |    2 +
 net/mac80211/cfg.c                    |   16 +++++++++++
 net/mac80211/driver-ops.h             |   23 +++++++++++++++
 net/mac80211/driver-trace.h           |   50 +++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c                |   30 +++++++++++++++++++-
 8 files changed, 174 insertions(+), 1 deletions(-)

-- 
Signature
