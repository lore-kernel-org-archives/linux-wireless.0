Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58469 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760351AbXHUPLU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 11:11:20 -0400
Message-Id: <20070821145905.689978000@sipsolutions.net>
Date: Tue, 21 Aug 2007 16:59:05 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 00/27] various cleanups and fixes for mac80211 and drivers
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've stripped my patch series down to those things that
nobody objected to. The ioctl removal is a bit slimmer
keeping the things Jouni wanted to keep.

This series contains:

 * mac80211: fix showing transmitted frames on multiple monitor interfaces
 * mac80211: fix preamble setting
 * mac80211: avoid copying packets to interfaces that are down
 * mac80211: fix key debugfs
 * mac80211, drivers: remove reset callback
 * ralink drivers: remove IEEE80211_HW_HOST_GEN_BEACON flag
 * mac80211: remove IEEE80211_HW_HOST_GEN_BEACON flag
 * mac80211: remove PRISM2_PARAM_RADIO_ENABLED
 * mac80211: remove PRISM2_HOSTAPD_SET_GENERIC_INFO_ELEM
 * ralink drivers: remove IEEE80211_HW_DATA_NULLFUNC_ACK
 * rtl8187: remove IEEE80211_HW_DATA_NULLFUNC_ACK
 * p54: remove IEEE80211_HW_DATA_NULLFUNC_ACK
 * mac80211: remove IEEE80211_HW_DATA_NULLFUNC_ACK
 * mac80211: ratelimit some RX messages
 * mac80211: remove ieee80211_msg_wep_frame_unknown_key
 * mac80211: remove radar stuff
 * mac80211: remove scan struct from hostapd_param
 * mac80211: fix software decryption
 * cfg80211: extend radiotap parser by all remaining fields
 * mac80211: remove unused ioctls (1)
 * mac80211: remove unused ioctls (2)
 * mac80211: remove unused ioctls (3)
 * mac80211: remove unused ioctls (4)
 * mac80211: remove PRISM2_PARAM_KEY_MGMT
 * mac80211: kill key_mgmt, use key_management_enabled
 * mac80211: refactor event sending
 * mac80211: use switch statement in tx code

johannes

