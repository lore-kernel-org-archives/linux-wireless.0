Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37713 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183AbaE1NTL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 09:19:11 -0400
Message-ID: <1401283140.8146.16.camel@jlt4.sipsolutions.net> (sfid-20140528_151914_600545_33A296B9)
Subject: Re: [RFC] trace-cmd: plugin_mac80211: add parsing for the new
 drv_switch_vif_chanctx
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
	michal.kazior@tieto.com
Date: Wed, 28 May 2014 15:19:00 +0200
In-Reply-To: <20140528090837.2b868d22@gandalf.local.home>
References: <1400873435-9687-1-git-send-email-luca@coelho.fi>
	 <1401088941.19055.0.camel@jlt4.sipsolutions.net>
	 <20140528090837.2b868d22@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-28 at 09:08 -0400, Steven Rostedt wrote:
> On Mon, 26 May 2014 09:22:21 +0200
> Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> > Steven, what do you think about those packed structs in a dynamic
> > array? I've applied the kernel patch but I can still back it out if you
> > know of a better solution.
> 
> I consider you more of the maintainer of the mac80211 plugin, so I'll
> leave that decision up to you ;-)

Heh, ok. I was more thinking about the structure of the kernel
tracepoint than the userspace code though.

johannes

