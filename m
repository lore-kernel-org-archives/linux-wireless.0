Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34459 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab1GRQKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 12:10:19 -0400
Message-Id: <20110718160834.876776560@sipsolutions.net> (sfid-20110718_181023_233341_F7849159)
Date: Mon, 18 Jul 2011 18:08:34 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] scan bitrate advertising
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

P2P requires to not advertise 11b rates in some
scans, but we scan on the main interface so we
need to know from userspace.

These two patches add the ability for userspace
to control the rates that are advertised.

johannes

