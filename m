Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:34137 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932629AbXBSUYJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 15:24:09 -0500
Date: Mon, 19 Feb 2007 21:24:07 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jkm@devicescape.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] remove IEEE80211_HW_FRAGLIST flag
Message-ID: <20070219212407.58e8fb62@griffin.suse.cz>
In-Reply-To: <1171642069.3575.4.camel@johannes.berg>
References: <1171569181.5220.60.camel@johannes.berg>
	<20070216160456.GA6173@instant802.com>
	<1171642069.3575.4.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 16 Feb 2007 17:07:49 +0100, Johannes Berg wrote:
> On Fri, 2007-02-16 at 08:04 -0800, Jouni Malinen wrote:
> 
> > The reason for this flag was to reduce host CPU load for frame
> > aggregation (merging multiple frames (skb's) into one frame. It was used
> > to implement one part of Atheros Super A/G enhancements, but I don't see
> > those proprietary changes being generic enough to be worth adding into
> > net/d80211. However, IEEE 802.11n has similar features that may indeed
> > benefit from this flag. As such, I would not remove it.
> 
> But we can never submit fragmented SKBs currently anyway, so whenever we
> do any 802.11n changes that benefit from it we can add the flag back.

I agree. Let's add the flag later when this is actually needed.

Applied, thanks for patch!

 Jiri

-- 
Jiri Benc
SUSE Labs
