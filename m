Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36815 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbaLQN6E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 08:58:04 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA256:128)
	(Exim 4.84)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Y1F74-0004BL-Kn
	for linux-wireless@vger.kernel.org; Wed, 17 Dec 2014 14:58:02 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/9] cfg80211/mac80211 statistics cleanups & features
Date: Wed, 17 Dec 2014 14:57:50 +0100
Message-Id: <1418824679-31530-1-git-send-email-johannes@sipsolutions.net> (sfid-20141217_145808_697234_0CC4B481)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patches consists of major cleanups to the statistics
framework, and the following new features:
 * non-channel-specific 'survey' data for allowing drivers to report
   global radio statistics (like the newly added scan time)
 * allow scan time reporting in survey
 * include statistics in station delete event so a userspace process
   listening can actually keep track of more global packet statistics
 * allow drivers to report some statistics, which is needed e.g. when
   beacon filtering is done, or similar (replacing get_rssi that the
   TI driver used)

johannes

