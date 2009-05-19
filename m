Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:59971 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751104AbZESOCX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 10:02:23 -0400
Message-Id: <20090519140137.708996030@atheros.com>
Date: Tue, 19 May 2009 17:01:37 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/7] ath9k/mac80211: Power save fixes 
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches addresses some more PS mode issues in ath9k and
mac80211. Some corner case issues are likely to remain even after this,
but at least all my basic tests passed with the end result; both with
timeout=500 (the default) and timeout=0 (PS-Poll).

-- 
Jouni Malinen                                            PGP id EFC895FA
