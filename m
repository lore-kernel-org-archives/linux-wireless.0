Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:56364 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755157AbYJ3PCr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 11:02:47 -0400
Message-Id: <20081030145920.233178987@localhost> (sfid-20081030_160252_212241_270D0781)
Date: Thu, 30 Oct 2008 16:59:20 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCHv2 0/5] mac80211/cfg80211/hwsim: Basic rate and TXQ params
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches add cfg80211/nl80211 attributes for configuring basic
rate set and TX queue parameters for AP mode. The current hostapd
development branch has matching userspace code for using the new
attributes. In addition, mac80211_hwsim is extended to show more
detailed debug information on BSS and TXQ changes.

v2 addresses the comments from Johannes and adds a patch to fix
kernel panics in certain rmmod mac80211_hwsim cases.

-- 
Jouni Malinen                                            PGP id EFC895FA
