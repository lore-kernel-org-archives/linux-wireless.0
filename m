Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51145 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934617AbZKYNik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 08:38:40 -0500
Message-Id: <20091125133243.163478670@sipsolutions.net>
Date: Wed, 25 Nov 2009 14:32:43 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/5] mac80211: stations per virtual interface, netdev
 reduction
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset finally converts station to fully be
managed per virtual interface.

There are also two patches to remove the use of netdevs
in mac80211.

I've been running with this for a while with a few
other scenarios too (like hwsim AP test) so I'm pretty
confident it works.

johannes

