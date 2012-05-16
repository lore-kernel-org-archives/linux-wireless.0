Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38312 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2EPUk4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 16:40:56 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] iwlwifi print formatting fixes
Date: Wed, 16 May 2012 22:40:48 +0200
Message-Id: <1337200851-20469-1-git-send-email-johannes@sipsolutions.net> (sfid-20120516_224100_707843_94781347)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are fixes for iwlwifi's debug statements and the
addition of the __printf attribute.

I ended up marking the %pM one for stable since I think
%pM can cause crashes if the pointer is completely bogus.

johannes

