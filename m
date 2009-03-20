Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:50680 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753061AbZCTTYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 15:24:00 -0400
Message-Id: <20090320192115.448175935@atheros.com> (sfid-20090320_202412_340028_DBDECEA4)
Date: Fri, 20 Mar 2009 21:21:15 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] nl80211: Cleanup cfg80211/mac80211 attribute validation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set moves some of the attribute validation from mac80211 into
cfg80211 so that it can be shared with non-mac80211 drivers, too. In
addition, this removes an unused command and adds some extra validation
for MLME attributes.

-- 
Jouni Malinen                                            PGP id EFC895FA
