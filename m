Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40636 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbXLSPrs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 10:47:48 -0500
Message-Id: <20071219010328.762470000@sipsolutions.net> (sfid-20071219_155048_843434_EB2FD833)
Date: Wed, 19 Dec 2007 02:03:28 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/9] nl80211/cfg80211/mac80211 updates for AP mode
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a repost of my previous patch series for some initial
AP mode support. With this series and the eapol handling patches
I just sent as well, there are only three ioctls required any   
more: 802.1X port control, frame bridging and hw features.   

I have for now removed the hw features ioctl from my tree so
hostapd will not currently work, I need to work on getting code
done to publish the hw features in nl80211 which would go on   
top of my cfg80211 bitrate/frequency API.

In any case, this is the patch series as I think it should be
merged for 2.6.25. In itself, it will not enable AP mode at all,
in fact most of the new API will not even be usable without
further patches, but I don't want to sit on it any longer. I'm   
hopeful that I've ironed out most issues these patches had when
I last posted them. 

johannes

