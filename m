Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:41584 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754176Ab0ELIXW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 04:23:22 -0400
Received: from vs3015.wh2.ocn.ne.jp (125.206.180.247)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0421862599
	for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 17:23:19 +0900 (JST)
Subject: [PATCH 0/3] antenna configuration
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, holgerschurig@gmail.com
Date: Wed, 12 May 2010 17:23:20 +0900
Message-ID: <20100512082231.26565.16730.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

resending my antenna patches addressing all previous comments.

bruno

---

Bruno Randolf (3):
      cfg80211: Add nl80211 antenna configuration
      mac80211: Add antenna configuration
      ath5k: Add support for antenna configuration


 drivers/net/wireless/ath/ath5k/base.c |   34 ++++++++++
 include/linux/nl80211.h               |   12 +++
 include/net/cfg80211.h                |    3 +
 include/net/mac80211.h                |    2 +
 net/mac80211/cfg.c                    |   16 +++++
 net/mac80211/driver-ops.h             |   23 +++++++
 net/mac80211/driver-trace.h           |   50 ++++++++++++++
 net/wireless/nl80211.c                |  116 +++++++++++++++++++++++++++++++++
 8 files changed, 256 insertions(+), 0 deletions(-)

-- 
Signature
