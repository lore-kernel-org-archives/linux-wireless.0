Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41560 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab2FTPML (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 11:12:11 -0400
Message-ID: <1340205127.4655.72.camel@jlt3.sipsolutions.net> (sfid-20120620_171215_122401_DC16A629)
Subject: Re: [PATCH 1/3] mac80211: Track auth frame registrations on IBSS
 ifaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Will Hawkins <hawkinsw@opentechinstitute.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Wed, 20 Jun 2012 17:12:07 +0200
In-Reply-To: <4FE1E579.3070307@opentechinstitute.org>
References: <cover.1340142553.git.hawkinsw@opentechinstitute.org>
	   <88045ffa83c9b4defb7b5eca98bc389ed6c2c5c1.1340142553.git.hawkinsw@opentechinstitute.org>
	  <1340170374.4655.1.camel@jlt3.sipsolutions.net>
	  <4FE1E0DA.8010406@opentechinstitute.org>
	 <1340203389.4655.71.camel@jlt3.sipsolutions.net>
	 <4FE1E579.3070307@opentechinstitute.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 11:00 -0400, Will Hawkins wrote:

> >> Just trying to make sure that it doesn't go negative. I am protecting
> >> against unmatched unregisters.
> > 
> > reg is a bool, did you mean "if (ifibss->auth_frame_registrations > 0)"?
> 
> Yes, of course I did. :-) Not sure how I missed that.
> 
> > 
> > in any case, you don't really have to care about unmatched unregisters
> > as cfg80211 tracks all of them anyway.
> 
> I will take that check out entirely and resubmit.
> 
> Is it proper protocol to resubmit this particular part of the patch or
> the entire set?

You can resend just this one patch as a reply to the original if you
wish, or the entire series (it's short, if it was 20 patches I'd ask you
not to do that :-) )

johannes

