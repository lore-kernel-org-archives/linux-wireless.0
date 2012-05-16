Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52877 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080Ab2EPUyg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 16:54:36 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/9] iwlwifi updates
Date: Wed, 16 May 2012 22:54:21 +0200
Message-Id: <1337201670-21604-1-git-send-email-johannes@sipsolutions.net> (sfid-20120516_225449_949313_3DBF184A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

This is the last batch of patches for now. These aren't important
in any way and should probably wait until after the merge window
closes again, but I'm sending them to you anyway already as I'll
be travelling & in meetings through next week.

One thing to note is that we split off some part of iwlwifi into
a new module "iwldvm" for "Dual Virtual MAC" (since it has support
for two virtual interfaces on some devices). This prepares for
adding more such "high-level" (for the driver anyway) modules to
support different firmware APIs on the same and new hardware.

Thanks,
Johannes

