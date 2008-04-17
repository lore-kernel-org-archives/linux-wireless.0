Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0708.google.com ([209.85.198.242]:32653 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761430AbYDQRWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 13:22:16 -0400
Received: by rv-out-0506.google.com with SMTP id k29so80083rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Apr 2008 10:22:16 -0700 (PDT)
Subject: Re: [PATCH-mm 1/3] mac80211: tkip.c use get/put_unaligned helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jiri Kosina <jkosina@suse.cz>, Jiri Benc <jbenc@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1208450454.4066.20.camel@johannes.berg>
References: <1208370570.11920.107.camel@brick>
	 <20080417105859.45092413@griffin.suse.cz>
	 <Pine.LNX.4.64.0804171102370.19002@twin.jikos.cz>
	 <1208450454.4066.20.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 17 Apr 2008 10:22:26 -0700
Message-Id: <1208452946.17196.1.camel@brick> (sfid-20080417_182220_411527_4603ADBA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-04-17 at 18:40 +0200, Johannes Berg wrote:
> > > I guess you are going to push this stuff through -mm altogether, right? 
> > > I can hardly take this into my tree right now, as the helpers are not in 
> > > Linus' tree yet.
> > 
> > yeah, sorry, that's been confusing a few people.
> > 
> > Strictly I'd merge the core infrastructure and then send the dependent 
> > patches into the relevant maintainers.  But that can mean than we 
> > needlessly miss the merge window, so it's most parctical to send along an 
> > acked-by and I'll merge the dependent patch directly with the appropriate 
> > ordering.
> 
> I guess what Jiri (Benc) is saying that *I* should ack them, not him.
> Jiri (Benc), maybe you care to move yourself down in the maintainers
> file?

I'll resubmit a cleaned up series anyways once the unaligned access
helpers get into mainline, so don't worry too much about this set I
suppose.

Cheers,

Harvey

