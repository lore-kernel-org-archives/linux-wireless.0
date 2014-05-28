Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:9640 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751466AbaE1OSQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 10:18:16 -0400
Date: Wed, 28 May 2014 10:18:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
	michal.kazior@tieto.com
Subject: Re: [RFC] trace-cmd: plugin_mac80211: add parsing for the new
 drv_switch_vif_chanctx
Message-ID: <20140528101814.400b20e2@gandalf.local.home> (sfid-20140528_161819_633485_5C1C57CD)
In-Reply-To: <1401283140.8146.16.camel@jlt4.sipsolutions.net>
References: <1400873435-9687-1-git-send-email-luca@coelho.fi>
	<1401088941.19055.0.camel@jlt4.sipsolutions.net>
	<20140528090837.2b868d22@gandalf.local.home>
	<1401283140.8146.16.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 28 May 2014 15:19:00 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Wed, 2014-05-28 at 09:08 -0400, Steven Rostedt wrote:
> > On Mon, 26 May 2014 09:22:21 +0200
> > Johannes Berg <johannes@sipsolutions.net> wrote:
> > 
> > > Steven, what do you think about those packed structs in a dynamic
> > > array? I've applied the kernel patch but I can still back it out if you
> > > know of a better solution.
> > 
> > I consider you more of the maintainer of the mac80211 plugin, so I'll
> > leave that decision up to you ;-)
> 
> Heh, ok. I was more thinking about the structure of the kernel
> tracepoint than the userspace code though.
> 

Where's the patch for the kernel? I can take a look at that. Most cases
if it works for you, then it should be fine.

-- Steve
