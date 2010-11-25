Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48410 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab0KYJDf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 04:03:35 -0500
Message-Id: <20101125090228.087298683@sipsolutions.net>
Date: Thu, 25 Nov 2010 10:02:28 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] off-channel TX support
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ultimate goal will be hardware offload
for this, but for now let's do software in
mac80211 to allow changing userspace.

This will already address some issues with
the current implementation, like extending
the timeouts that will now be implicit.

johannes

