Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37182 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab1GYP3Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2011 11:29:24 -0400
Received: by wwe5 with SMTP id 5so4190491wwe.1
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2011 08:29:23 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [RFC 0/2] mac80211 offchannel fixes
Date: Mon, 25 Jul 2011 18:29:21 +0300
Message-Id: <1311607763-12603-1-git-send-email-eliad@wizery.com> (sfid-20110725_172927_564433_B9DDB665)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was working on some roaming scenarios, and encountered some pretty
fundamental offchannel issues. i'm not familiar enough with this
code, so there's a good chance the patches are all wrong.

I'd be glad for your review.
Eliad.

Eliad Peller (2):
  mac80211: fix remain_off_channel regression
  mac80211: config hw when going back on-channel

 net/mac80211/work.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

