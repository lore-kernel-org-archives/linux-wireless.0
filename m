Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:49800 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241AbZCSLsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 07:48:12 -0400
Message-Id: <20090319113918.555693846@atheros.com> (sfid-20090319_124815_784938_C7822024)
Date: Thu, 19 Mar 2009 13:39:18 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] nl80211/mac80211: Add MLME primitives for auth/assoc
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches fixes couple of small bugs in mac80211 and adds
support for nl80211-based connection request for station mode. These
apply as-is on top of the current wireless-testing.git, but locking
order matches the one introduced in "nl80211: rework locking" from
Johannes, so these should be applied only after it has been applied.

I have matching code for wpa_supplicant to use the new commands, but
have not yet committed it into the main development tree. I can make
patches available if someone is interested in testing this before the
changes go into wireless-testing.git, but anyway, I will be adding these
to the 0.7.x tree as soon as the kernel side is available in the git
tree.

-- 
Jouni Malinen                                            PGP id EFC895FA
