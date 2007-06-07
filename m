Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:53260 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753575AbXFGVGE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 17:06:04 -0400
Date: Thu, 7 Jun 2007 23:06:10 +0200
From: Jiri Benc <jbenc@suse.cz>
To: "Jouni Malinen" <jkm@devicescape.com>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] mac80211: rc80211_lowest, a dumb rate control algorithm
Message-ID: <20070607230610.0631786c@griffin.suse.cz>
In-Reply-To: <20070607205431.GD26739@devicescape.com>
References: <20070607222113.0f752bf8@griffin.suse.cz>
	<20070607222210.1a445cd7@griffin.suse.cz>
	<20070607205431.GD26739@devicescape.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 7 Jun 2007 13:54:31 -0700, Jouni Malinen wrote:
> On Thu, Jun 07, 2007 at 10:22:10PM +0200, Jiri Benc wrote:
> > This allows the lowest rate to be used all time.
> 
> > +MODULE_DESCRIPTION("Forced 1 mbps rate control module for mac80211");
> 
> That "1 mbps" should be "lowest supported". In case of 802.11a, this is
> likely to be 6 Mbps.

True. I was thinking too much about bcm43xx when writing that. But the
code should be OK, it's mostly copied from rc80211_simple :-)

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
