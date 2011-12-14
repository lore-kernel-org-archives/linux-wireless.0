Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43858 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab1LNLX5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 06:23:57 -0500
Message-Id: <20111214112026.409514167@sipsolutions.net> (sfid-20111214_122400_723641_73C1DD48)
Date: Wed, 14 Dec 2011 12:20:26 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/5] station management rework
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thomas was kind enough to look at the previous
patchset for mesh station handling, and I think
this new patchset addresses his concerns.

Arik also helped me look at TDLS, which should
be handled correctly now.

johannes
