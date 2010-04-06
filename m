Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47114 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab0DFJWj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 05:22:39 -0400
Message-Id: <20100406091841.549805267@sipsolutions.net>
Date: Tue, 06 Apr 2010 11:18:41 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/7] mac80211 fixes
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are a few mac80211 fixes, I'll let you decide
which trees to add them to. The first one is only
relevant for -34 and should probably be applied there
to avoid all the warnings.

The other ones in theory apply to some previous
versions, but nobody seems to have run into any
of the problems, and they are quite unlikely to
actually happen due to the way the code is otherwise
structured and the amount of code in there. I
was reluctant to add stable tags to all of them
for that reason since they're quite big.

johannes

