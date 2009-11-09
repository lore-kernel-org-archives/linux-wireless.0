Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:47150 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbZKIXq5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 18:46:57 -0500
Received: by ewy28 with SMTP id 28so3974559ewy.18
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 15:47:01 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2 00/20] o11s update to latest draft
Date: Mon,  9 Nov 2009 23:46:38 +0000
Message-Id: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again,

Here's take two of the mesh update patch. As I already said, the following
patches update the mesh code to latest draft, 3.03. They also include some
minor cleanups and improved debugging.

 include/linux/ieee80211.h     |   17 +
 include/linux/nl80211.h       |   11 -
 include/net/cfg80211.h        |    9 
 net/mac80211/Kconfig          |   13 +
 net/mac80211/cfg.c            |   15 +
 net/mac80211/debugfs_netdev.c |    2 
 net/mac80211/ieee80211_i.h    |   23 +-
 net/mac80211/mesh.c           |  143 ++++++++-----
 net/mac80211/mesh.h           |   30 +-
 net/mac80211/mesh_hwmp.c      |  454 +++++++++++++++++++++++++++---------------
 net/mac80211/mesh_pathtbl.c   |   20 +
 net/mac80211/mesh_plink.c     |   56 +++--
 net/mac80211/rx.c             |    2 
 net/mac80211/tx.c             |    2 
 net/mac80211/util.c           |    6 
 net/wireless/nl80211.c        |   12 -
 16 files changed, 541 insertions(+), 274 deletions(-)

Regards,
--
Rui Paulo
