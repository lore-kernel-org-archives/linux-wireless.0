Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57888 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbXHNLnR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 07:43:17 -0400
Message-Id: <20070814092008.627058000@sipsolutions.net>
Date: Tue, 14 Aug 2007 11:20:08 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 00/13] mac80211 cleanups
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wholesale ioctl removals, some cleanups and fixes.

Please apply all patches but the PRISM2_PARAM_NEXT_MODE removal,
I want some discussion on that first how we want to handle B vs.
G channels on G capable hardware unlike now where we just don't 
handle it because drivers only specify G channels (rightfully  
IMHO.) 

johannes

