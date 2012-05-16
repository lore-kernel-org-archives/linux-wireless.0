Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41658 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758544Ab2EPVzC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 17:55:02 -0400
Message-Id: <20120516215014.379333357@sipsolutions.net> (sfid-20120516_235510_681492_B200683C)
Date: Wed, 16 May 2012 23:50:14 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/7] cfg80211/mac80211 channel redesign
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Sorry about the previous set of patches, they didn't
include the first in this set and thus couldn't apply.

These patches prepare cfg80211/mac80211 more for the
new multi-channel feature everybody has been waiting
for. The trick there is that we need to explicitly
know when to use a certain channel, so I move all the
channel information into the actual start functions,
e.g. join-mesh, start-AP etc.

johannes

