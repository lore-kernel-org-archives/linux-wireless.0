Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38704 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab2ATMxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 07:53:50 -0500
Message-Id: <20120120125235.243434836@sipsolutions.net> (sfid-20120120_135353_907710_0AC0A5B5)
Date: Fri, 20 Jan 2012 13:52:35 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] fix shadow warnings
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the variables are useless ... it looks
like -Wshadow is no longer default though.

johannes
