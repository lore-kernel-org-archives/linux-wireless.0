Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43148 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbbFLUKf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 16:10:35 -0400
Message-ID: <1434139832.2679.38.camel@sipsolutions.net> (sfid-20150612_221037_676481_100A8977)
Subject: Re: [PATCH] mac80211: fix a NULL dereference in ath9k (and likely
 other drivers) when fixed mesh paths are used
From: Johannes Berg <johannes@sipsolutions.net>
To: Jesse Jones <jjones@cococorp.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	Alexis Green <agreen@cococorp.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 12 Jun 2015 22:10:32 +0200
In-Reply-To: <c305826859e4f12efb163463f7283d5a@mail.gmail.com> (sfid-20150612_200140_212820_5F599172)
References: <CAAnMG+OgtSzFXqLOoZ-JbOr7xnexC3P0+M0fFLWTBtWru=4SKg@mail.gmail.com>
	 <20150525161542.GA14318@localhost>
	 <c305826859e4f12efb163463f7283d5a@mail.gmail.com>
	 (sfid-20150612_200140_212820_5F599172)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-06-12 at 11:01 -0700, Jesse Jones wrote:

> I had trouble reproing the reboot caused by ath9k de-referencing NULL
> pointers but after a fair amount of work I was able to consistently get
> reboots. Your patch *does* fix the problem so I am going to switch our repo
> over to your patch instead of what we were using. Thanks for the help.

Great. Bob, if it's no bother I'd appreciate if you'd resend the patch
correctly so it gets picked up by patchwork etc.

Thanks,
johannes

