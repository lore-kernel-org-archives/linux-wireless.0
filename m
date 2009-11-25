Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53872 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbZKYQtw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 11:49:52 -0500
Message-Id: <20091125164614.427835023@sipsolutions.net>
Date: Wed, 25 Nov 2009 17:46:14 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 0/5] mac80211: stations per virtual interface, netdev
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
confident it works. And this time it actually does work
in more test scenarios ...

johannes

