Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46006 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbYAXSre (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 13:47:34 -0500
Message-Id: <20080124183837.577631000@sipsolutions.net> (sfid-20080124_184743_325899_9AFE434A)
Date: Thu, 24 Jan 2008 19:38:37 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] the long-awaited bitrate/channel API update
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Having just rebased my patch on top of the new fixes Reinette posted
(thanks!) that were previously a show-stopper for iwlwifi, here's now
finally the submission of these two patches.

There will undoubtedly be bugs in this as I don't have the necessary
hardware to test, and I'm sure people will disagree with the regulatory
control change. I think we all agree, however, that the new API is
better and that the regulatory control configuration should be within
the new API. I will continue to work in this area but I hope that with
this patch in other people can help out as well, both fixing bugs and
fixing the small regulatory control regressions.

Since I know 1/2 won't make it to the list, here's the URL:
http://johannes.sipsolutions.net/patches/kernel/all/2008-01-24-18%3a41/018-cfg80211-channel-and-bitrate-api.patch

johannes

