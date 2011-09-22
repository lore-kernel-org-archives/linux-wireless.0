Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43843 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab1IVPwU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 11:52:20 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1R6lZT-0002V3-DQ
	for linux-wireless@vger.kernel.org; Thu, 22 Sep 2011 17:52:19 +0200
Subject: Re: [RFC 00/15] mac80211 uAPSD support
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <20110922154726.521122680@sipsolutions.net> (sfid-20110922_174947_979028_29114A90)
References: <20110922154726.521122680@sipsolutions.net>
	 (sfid-20110922_174947_979028_29114A90)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Sep 2011 17:52:16 +0200
Message-ID: <1316706736.3899.54.camel@jlt3.sipsolutions.net> (sfid-20110922_175224_975994_9E1DF518)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oops, forgot the total diffstat:

 Documentation/DocBook/80211.tmpl            |   11 
 drivers/net/wireless/ath/ath9k/ath9k.h      |    3 
 drivers/net/wireless/ath/ath9k/main.c       |    3 
 drivers/net/wireless/ath/ath9k/xmit.c       |   14 
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c |    2 
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |    2 
 drivers/net/wireless/p54/txrx.c             |    2 
 include/net/mac80211.h                      |  225 +++++++
 net/mac80211/agg-rx.c                       |    2 
 net/mac80211/agg-tx.c                       |    2 
 net/mac80211/cfg.c                          |   33 -
 net/mac80211/debugfs_sta.c                  |   54 +
 net/mac80211/driver-ops.h                   |   30 +
 net/mac80211/driver-trace.h                 |   57 +
 net/mac80211/ht.c                           |    2 
 net/mac80211/ibss.c                         |    4 
 net/mac80211/ieee80211_i.h                  |   16 
 net/mac80211/iface.c                        |    4 
 net/mac80211/key.c                          |    4 
 net/mac80211/main.c                         |   14 
 net/mac80211/mesh_plink.c                   |    8 
 net/mac80211/mlme.c                         |   22 
 net/mac80211/pm.c                           |    2 
 net/mac80211/rx.c                           |  127 ++--
 net/mac80211/sta_info.c                     |  816 ++++++++++++++++++++--------
 net/mac80211/sta_info.h                     |  137 +---
 net/mac80211/status.c                       |   60 +-
 net/mac80211/tx.c                           |  111 +--
 net/mac80211/util.c                         |   19 
 net/mac80211/wme.c                          |    4 
 30 files changed, 1268 insertions(+), 522 deletions(-)

johannes

