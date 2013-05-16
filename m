Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59206 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab3EPVDm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 17:03:42 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Ud5Kv-0005HK-5u
	for linux-wireless@vger.kernel.org; Thu, 16 May 2013 23:03:41 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/9] cfg80211 spring cleaning
Date: Thu, 16 May 2013 23:03:29 +0200
Message-Id: <1368738218-7597-1-git-send-email-johannes@sipsolutions.net> (sfid-20130516_230344_782376_FD5FAA84)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Motivated by the bugs Ben Greear keeps reporting, I decided to do
some locking and general cleanup in cfg80211.

This is the first series. I'm working on more changes to actually
separate the SME and MLME code much better to avoid such strange
issues as we had before with their state (sme_state and current_bss)
getting confused, but that'll take a bit longer.

johannes

