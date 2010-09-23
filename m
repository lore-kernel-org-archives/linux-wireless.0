Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49390 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab0IWOGd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 10:06:33 -0400
Subject: Re: [mac80211] mac80211:  Support receiving data frames on
 multiple vifs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4C9B5CE4.9040806@candelatech.com>
References: <1285018776-21795-1-git-send-email-greearb@candelatech.com>
	 <1285051641.3710.8.camel@jlt3.sipsolutions.net>
	 <4C9B5CE4.9040806@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 16:06:32 +0200
Message-ID: <1285250792.3770.110.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-23 at 06:57 -0700, Ben Greear wrote:
> On 09/20/2010 11:47 PM, Johannes Berg wrote:
> > On Mon, 2010-09-20 at 14:39 -0700, greearb@candelatech.com wrote:
> >> From: Ben Greear<greearb@candelatech.com>
> >>
> >> When using multiple STA interfaces on the same radio, some
> >> data packets need to be received on all interfaces
> >> (broadcast, for instance).
> >>
> >> Make the STA loop look similar to the mgt-data loop.
> >>
> >> Also, add logic to check RX_FLAG_MMIC_ERROR for last
> >> interface in mgt-data loop.
> >>
> >> This needs review.
> >
> > Looks fine to me, I think.
> 
> Does this need any more work before being accepted upstream?

Well, I personally would've tried to reduce the code duplication between
the two loops, but right now I'm not sure I see how to.

johannes

