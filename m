Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:56166 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbZKIMjj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 07:39:39 -0500
Received: by fxm21 with SMTP id 21so156761fxm.21
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 04:39:43 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: o11s update to latest draft
Date: Mon,  9 Nov 2009 12:39:20 +0000
Message-Id: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

The following patches update the mesh code to latest draft, 3.03.
They also include some minor cleanups and improved debugging.

 include/linux/ieee80211.h     |    3 
 include/linux/nl80211.h       |   11 
 include/net/cfg80211.h        |    9 
 net/mac80211/Kconfig          |   13 +
 net/mac80211/cfg.c            |   15 -
 net/mac80211/debugfs_netdev.c |    2 
 net/mac80211/ieee80211_i.h    |   23 +-
 net/mac80211/mesh.c           |  143 ++++++++----
 net/mac80211/mesh.h           |   30 +-
 net/mac80211/mesh_hwmp.c      |  465 +++++++++++++++++++++++++++---------------
 net/mac80211/mesh_pathtbl.c   |   20 -
 net/mac80211/mesh_plink.c     |   56 +++--
 net/mac80211/rx.c             |    2 
 net/mac80211/tx.c             |    2 
 net/mac80211/util.c           |    4 
 net/wireless/nl80211.c        |   12 -
 16 files changed, 535 insertions(+), 275 deletions(-)

Regards,
--
Rui Paulo
