Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41753 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab2HUQ5S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 12:57:18 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 3.6 0/2] iwlwifi fixes
Date: Tue, 21 Aug 2012 18:57:09 +0200
Message-Id: <1345568231-20584-1-git-send-email-johannes@sipsolutions.net> (sfid-20120821_185721_849720_81B17EFA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John, all,

Here are two iwlwifi fixes I'd like to get into 3.6, for
debugfs issues. Ben reported one of the issues, and then
I found the other one by trying similar things that he had
done to find the first :)

johannes

