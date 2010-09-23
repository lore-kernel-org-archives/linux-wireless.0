Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42300 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab0IWSmV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 14:42:21 -0400
Subject: Re: [mac80211] mac80211:  Support receiving data frames on
 multiple vifs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4C9B8703.7070907@candelatech.com>
References: <1285018776-21795-1-git-send-email-greearb@candelatech.com>
	 <1285051641.3710.8.camel@jlt3.sipsolutions.net>
	 <4C9B5CE4.9040806@candelatech.com>
	 <1285250792.3770.110.camel@jlt3.sipsolutions.net>
	 <4C9B8703.7070907@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 20:42:15 +0200
Message-ID: <1285267335.3770.400.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-23 at 09:57 -0700, Ben Greear wrote:

> > Well, I personally would've tried to reduce the code duplication between
> > the two loops, but right now I'm not sure I see how to.
> 
> I could move some of the rx setup code into prepare_for_handlers,
> but not sure how much that would help readability.
> 
> In my opinion, that would be a good candidate for a followup
> patch instead of adding that to this patch, though.

Yeah, I can agree with that.

I have a patch that also touches this area, I'll let you get this one in
first and rebase it.

Thanks,
Johannes

