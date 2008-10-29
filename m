Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:45124 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730AbYJ2RxN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 13:53:13 -0400
Message-Id: <20081029174934.817700763@localhost> (sfid-20081029_185318_158590_C73759DA)
Date: Wed, 29 Oct 2008 19:49:34 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] mac80211/cfg80211/hwsim: Basic rate and TXQ params
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches add cfg80211/nl80211 attributes for configuring basic
rate set and TX queue parameters for AP mode. The current hostapd
development has matching userspace code for using the new attributes. In
addition, mac80211_hwsim is extended to show more detailed debug
information on BSS and TXQ changes.

-- 
Jouni Malinen                                            PGP id EFC895FA
