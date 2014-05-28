Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37908 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531AbaE1Oax (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 10:30:53 -0400
Message-ID: <1401287435.8146.27.camel@jlt4.sipsolutions.net> (sfid-20140528_163056_599573_A9BC7404)
Subject: Re: [RFC] trace-cmd: plugin_mac80211: add parsing for the new
 drv_switch_vif_chanctx
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
	michal.kazior@tieto.com
Date: Wed, 28 May 2014 16:30:35 +0200
In-Reply-To: <20140528101814.400b20e2@gandalf.local.home>
References: <1400873435-9687-1-git-send-email-luca@coelho.fi>
	 <1401088941.19055.0.camel@jlt4.sipsolutions.net>
	 <20140528090837.2b868d22@gandalf.local.home>
	 <1401283140.8146.16.camel@jlt4.sipsolutions.net>
	 <20140528101814.400b20e2@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-28 at 10:18 -0400, Steven Rostedt wrote:

> > Heh, ok. I was more thinking about the structure of the kernel
> > tracepoint than the userspace code though.
> > 
> 
> Where's the patch for the kernel? I can take a look at that. Most cases
> if it works for you, then it should be fine.

This:
http://mid.gmane.org/1400844793-18069-1-git-send-email-luca@coelho.fi


johannes

