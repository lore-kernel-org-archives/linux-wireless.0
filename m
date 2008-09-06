Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33865 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbYIFWOW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 18:14:22 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [RFC PATCH 0/3] mac80211 dissasociation
Date: Sun,  7 Sep 2008 01:14:16 +0300
Message-Id: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com> (sfid-20080907_001426_567852_EB9B55D8)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series should fix mac problems in disassociation
There are two basic problems disassociation in current implementation.
The order of steps in the dissociation flow and missing proper
disassociation when moving from one AP to another. 
 
One more missing piece not addressed by these patches is how
to notify mac80211 about rfkill. It can be done via mac_notify callback
or by rf kill notification chain. I didn't explore the later yet.
 
I'm releasing this as RFC because I didn't tested it after rebasing
to current wireless-testing. (Will do soon)
 
Tomas


---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

