Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33293 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967705AbaLLM7v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 07:59:51 -0500
Message-ID: <1418389179.2470.43.camel@sipsolutions.net> (sfid-20141212_135954_168842_A6A98282)
Subject: Re: New WARNING from mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 12 Dec 2014 13:59:39 +0100
In-Reply-To: <21595.39090.446262.985148@gargle.gargle.HOWL>
References: <545B8CD1.8020208@lwfinger.net>
	 <1415286217.17015.12.camel@sipsolutions.net>
	 <21595.38533.767426.846290@gargle.gargle.HOWL>
	 <21595.39090.446262.985148@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-11-06 at 21:20 +0530, Sujith Manoharan wrote:
> Sujith Manoharan wrote:
> > I think this is the race described here: https://patchwork.kernel.org/patch/5095061/
> > 
> > I haven't tried any workaround or fix yet, but it looks like this
> > race can be hit fairly often.
> > 
> > https://dev.openwrt.org/ticket/9654
> > https://dev.openwrt.org/ticket/11862
> > https://dev.openwrt.org/ticket/13542
> 
> I dug out an old trace: http://pastebin.com/raw.php?i=Qj8aXJhB

Would it be worthwhile to simply remove the warning and document how we
can get there?

johannes

