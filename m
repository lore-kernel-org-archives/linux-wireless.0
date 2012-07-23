Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35099 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab2GWNaQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 09:30:16 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1StIiE-0001Ig-6L
	for linux-wireless@vger.kernel.org; Mon, 23 Jul 2012 15:30:14 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC/RFT 0/6] mac80211 oper_channel changes
Date: Mon, 23 Jul 2012 15:30:05 +0200
Message-Id: <1343050211-499-1-git-send-email-johannes@sipsolutions.net> (sfid-20120723_153037_143560_2570CDF2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When reviewing code for the multi-channel changes, I had
noticed that a lot of places use hw.conf.channel when they
should be using oper_channel instead. This patches changes
most places, but we keep some that really need to be the
*current* channel rather than the operating channel.

Please review/test :-)

johannes

