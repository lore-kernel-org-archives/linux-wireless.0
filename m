Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2114 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbZASQXT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 11:23:19 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH v3 0/3] mac80211 suspend/resume support
Date: Mon, 19 Jan 2009 11:20:51 -0500
Message-Id: <1232382054-15931-1-git-send-email-me@bobcopeland.com> (sfid-20090119_172329_862263_32A8384E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here's version 3 of suspend/resume for mac80211.

version 3:
 - minor commit log fixes
 - no code changes, just rebased on latest w-t and retested on 2.6.29-rc2

version 2:

 - fixed broken conditional for monitor & ap vlan checking
 - removed pm.h
 - removed frag threshold setting since that's gone now
 - the call to ieee80211_sta_tear_down_BA_sessions was locking up so 
   I just dropped it for now in the interest of getting a stable base


