Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39786 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827AbZKSADF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 19:03:05 -0500
Message-Id: <20091118235627.209099206@sipsolutions.net>
Date: Thu, 19 Nov 2009 00:56:27 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org
Subject: [PATCH 0/3] cfg80211 capa/4addr improvements, disallow bridging
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So I wanted to move the bridging stuff into cfg80211
and ended up reworking a bunch of things to actually
make that possible.

johannes

