Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3776 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754771AbXE3TBL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2007 15:01:11 -0400
Date: Wed, 30 May 2007 14:25:38 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/4] mac80211 fixes for 2.6.22
Message-ID: <20070530182538.GB3610@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some bug fixes that should be applied to 2.6.22:

      mac80211: fail back to use associate from reassociate
      mac80211: fix memory leak when defrag fragments
      mac80211: always set carrier status on open
      mac80211: avoid null ptr deref in ieee80211_ibss_add_sta

These are also available in the wireless-2.6 git tree:

	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git mac80211

Please apply at your earliest convenience!

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
