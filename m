Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:47479 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753490AbaE1OfH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 10:35:07 -0400
Message-ID: <1401287690.29067.4.camel@dubbel> (sfid-20140528_163512_835588_572EDBEA)
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	linux-wireless@vger.kernel.org, michal.kazior@tieto.com
Date: Wed, 28 May 2014 17:34:50 +0300
In-Reply-To: <1401287435.8146.27.camel@jlt4.sipsolutions.net>
References: <1400873435-9687-1-git-send-email-luca@coelho.fi>
	 <1401088941.19055.0.camel@jlt4.sipsolutions.net>
	 <20140528090837.2b868d22@gandalf.local.home>
	 <1401283140.8146.16.camel@jlt4.sipsolutions.net>
	 <20140528101814.400b20e2@gandalf.local.home>
	 <1401287435.8146.27.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [RFC] trace-cmd: plugin_mac80211: add parsing for the new
 drv_switch_vif_chanctx
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-28 at 16:30 +0200, Johannes Berg wrote:
> On Wed, 2014-05-28 at 10:18 -0400, Steven Rostedt wrote:
> 
> > > Heh, ok. I was more thinking about the structure of the kernel
> > > tracepoint than the userspace code though.
> > > 
> > 
> > Where's the patch for the kernel? I can take a look at that. Most cases
> > if it works for you, then it should be fine.
> 
> This:
> http://mid.gmane.org/1400844793-18069-1-git-send-email-luca@coelho.fi

This link is not working for me (I was just trying the same), but the
patch can also be seen here:

https://git.kernel.org/cgit/linux/kernel/git/jberg/mac80211-next.git/commit/?id=1a5f0c13d1a8808c2bdd00630818ed491e1719f5

--
Luca.

