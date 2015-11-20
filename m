Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52805 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162980AbbKTP3h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2015 10:29:37 -0500
Message-ID: <1448033373.3141.46.camel@sipsolutions.net> (sfid-20151120_162940_123959_7801B6D3)
Subject: Re: [RFC v5 4/5] mac80211: use Kconfig counters to elide
 unnecessary code
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Marek <mmarek@suse.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 20 Nov 2015 16:29:33 +0100
In-Reply-To: <564F3B36.4040101@suse.com>
References: <1447365652-23716-1-git-send-email-johannes@sipsolutions.net>
	 <1447365652-23716-5-git-send-email-johannes@sipsolutions.net>
	 <564F3B36.4040101@suse.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-11-20 at 16:24 +0100, Michal Marek wrote:
> On 2015-11-12 23:00, Johannes Berg wrote:
> > +	count MAC80211_NUM_DRIVERS
> > +	select MAC80211_DRIVER_NO_HWFLAGS
> 
> Hi Johannes,
> 
> The MAC80211_DRIVER_NO_HWFLAGS config does not seem to be used
> anywhere in the logic.
> 

Yeah, I forgot in this version. I have an updated one at

https://git.kernel.org/cgit/linux/kernel/git/jberg/mac80211-next.git/lo
g/?h=hwflags-elide

haven't sent it yet though because I'm not really sure it's worth it at
all?

johannes
