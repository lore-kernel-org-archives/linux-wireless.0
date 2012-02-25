Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49524 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab2BYUn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Feb 2012 15:43:58 -0500
Message-Id: <20120225204044.168176239@sipsolutions.net> (sfid-20120225_214402_554428_80FA3860)
Date: Sat, 25 Feb 2012 21:40:44 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] two mac80211 fixes
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One fix for a bug introduced in my auth/assoc
redesign, and a fix for a buglet that masked a
warning we should have gotten in the other case
which would have helped debugging it.

johannes
