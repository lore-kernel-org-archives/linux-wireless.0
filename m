Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50417 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbYJACZx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 22:25:53 -0400
Received: from sapphire.tuxdriver.com ([70.61.120.61] helo=linville-t43.local)
	by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1KkrPU-0007rJ-Af
	for linux-wireless@vger.kernel.org; Tue, 30 Sep 2008 22:25:52 -0400
Received: from linville-t43.local (linville-t43.local [127.0.0.1])
	by linville-t43.local (8.14.2/8.14.2) with ESMTP id m912Frbm002198
	for <linux-wireless@vger.kernel.org>; Tue, 30 Sep 2008 22:21:13 -0400
Received: (from linville@localhost)
	by linville-t43.local (8.14.2/8.14.2/Submit) id m912Fq6n002197
	for linux-wireless@vger.kernel.org; Tue, 30 Sep 2008 22:15:52 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/5] wireless: single escape_essid implementation and related cleanups
Date: Tue, 30 Sep 2008 22:15:47 -0400
Message-Id: <1222827352-1978-1-git-send-email-linville@tuxdriver.com> (sfid-20081001_042555_515889_ED71740D)
In-Reply-To: <1222294536-24367-1-git-send-email-linville@tuxdriver.com>
References: <1222294536-24367-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a repost of my escape_essid consolidation.  Also included are
some suggested changes from the original post and a few cleanups.  There
is still plenty to be done -- of course, this isn't really high priority
work either...

[PATCH 1/5] wireless: consolidate on a single escape_essid implementation
[PATCH 2/5] wireless: remove NETWORK_EMPTY_ESSID flag
[PATCH 3/5] wireless: escape_ssid should handle non-printables
[PATCH 4/5] wireless: use individual buffers for printing ssid values
[PATCH 5/5] wireless: avoid some net/ieee80211.h vs. linux/ieee80211.h conflicts

Comments welcome!

John
--
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
