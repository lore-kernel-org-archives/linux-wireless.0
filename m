Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46337 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab2EJHKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 03:10:17 -0400
Message-Id: <20120510070909.253886400@sipsolutions.net> (sfid-20120510_091025_996699_E9F6F8EF)
Date: Thu, 10 May 2012 09:09:09 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] add HT format to radiotap
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The iwlwifi patch is only as RFC since I should
push it through our internal tree first, the
mac80211 patch allows us to add HT format to the
MCS field in radiotap.

johannes

