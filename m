Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57798 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758505Ab0G3MKn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 08:10:43 -0400
Message-Id: <20100730113045.923567583@sipsolutions.net>
Date: Fri, 30 Jul 2010 13:30:45 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: wey-yi.w.guy@intel.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] hw scan fixes
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm rolling these up because without the iwlwifi
fix I'm pretty sure we will also get lockdep
warnings even if the actual deadlock scenario
is rather unlikely to start with.

Technically these are 2.6.35 regressions, but
I guess it's a little late?

johannes

