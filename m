Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59350 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab2FVRSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 13:18:47 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Si7VO-000665-C6
	for linux-wireless@vger.kernel.org; Fri, 22 Jun 2012 19:18:46 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 0/6] mac80211 debugging
Date: Fri, 22 Jun 2012 19:18:39 +0200
Message-Id: <1340385525-14487-1-git-send-email-johannes@sipsolutions.net> (sfid-20120622_191850_502990_C5B7686A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a respin. I don't really care about the trailing
newlines so I've included them (and cleaned up all cases
where it was missing), and I've used #define DEBUG to
keep using pr_debug in the actual debug cases.

johannes

