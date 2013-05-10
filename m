Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36360 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab3EJMIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 May 2013 08:08:16 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: greearb@candelatech.com
Subject: [RFC 0/4] cfg80211/mac80211: simplify locking
Date: Fri, 10 May 2013 14:08:05 +0200
Message-Id: <1368187689-29706-1-git-send-email-johannes@sipsolutions.net> (sfid-20130510_140823_865843_217BECE5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I got a little fed up with all the locking, and decided to simplify.

This should still work, but I've only done some very simple tests.
I'm hoping it'll fix some of the weird corner cases that Ben and
others have found, which may be due to different locks in different
cases and things racing against each other ... I'm not convinced it
really will though, but hey, who knows :)

johannes

