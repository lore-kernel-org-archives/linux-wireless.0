Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37444 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbbAWQEe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 11:04:34 -0500
Message-ID: <1422029065.2728.40.camel@sipsolutions.net> (sfid-20150123_170437_703306_C6C1D139)
Subject: Re: [RFC iw next] phy: Allow set netns by fd
From: Johannes Berg <johannes@sipsolutions.net>
To: Vadim Kochan <vadim4j@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Jan 2015 17:04:25 +0100
In-Reply-To: <20150123154731.GA9454@angus-think.wlc.globallogic.com> (sfid-20150123_165824_857317_15B252D3)
References: <1422026027-5806-1-git-send-email-vadim4j@gmail.com>
	 <1422027267.2728.39.camel@sipsolutions.net>
	 <20150123154731.GA9454@angus-think.wlc.globallogic.com>
	 (sfid-20150123_165824_857317_15B252D3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-23 at 17:47 +0200, Vadim Kochan wrote:

> OK, just to clarify with nl80211.h - you will update it including new
> NL80211_ATTR_NETNS_FD ? If yes - I will wait for this change.

No, don't wait for it - just commit it locally separately for testing,
but send me only the actual code changes. I'll then do the update when I
apply your patch.

johannes

