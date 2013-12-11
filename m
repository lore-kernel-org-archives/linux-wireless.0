Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40846 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab3LKQAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 11:00:16 -0500
Date: Wed, 11 Dec 2013 10:50:50 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi-next 2013-12-2
Message-ID: <20131211155049.GC7411@tuxdriver.com> (sfid-20131211_170038_310191_5D18EDB2)
References: <529CF2D6.1080008@gmail.com>
 <529E129B.6080807@gmail.com>
 <20131209202724.GB3359@tuxdriver.com>
 <52A62A58.5060708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52A62A58.5060708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 09, 2013 at 10:38:48PM +0200, Emmanuel Grumbach wrote:
> 
> 
> On 12/09/2013 10:27 PM, John W. Linville wrote:
> > On Tue, Dec 03, 2013 at 07:19:23PM +0200, Emmanuel Grumbach wrote:
> >>
> >>
> >> On 12/02/2013 10:51 PM, Emmanuel Grumbach wrote:
> >>> Hi John,
> >>>
> >>> This is the fixed and enlarged pull request for 3.14. It includes the
> >>> patches in my previous pull request that was based on a bad patch.
> >>>
> >>> I have here a big rework of the rate control by Eyal. This is obviously
> >>> the biggest part of this batch.
> >>> I also have enhancement of protection flags by Avri and a few bits for
> >>> WoWLAN by Eliad and Luca. Johannes cleans up the debugfs plus a few
> >>> fixes. I provided a few things for Bluetooth coexistence.
> >>> Besides this we have an implementation for low priority scan.
> >>>
> >>> Note that I had to merge iwlwifi-fixes into -next to solve conflicts
> >>> before they hit linux-next.
> >>> Please let me know about issues you may face - Thanks!
> >>>
> >>
> >> So - I found out that merging iwlwifi-fixes wasn't a good idea... So I
> >> updated my tree and added a trivial compilation fix.
> >>
> >> New head: 2f579448f3a60c8ede544dd0951b8d2a2e282ba2.
> >>
> >> I hope that I have done all the possible mistakes now and that next time
> >> I will get it right the first time... Sorry for all the mess...
> > 
> > This has a couple of merge conflicts when pulling it into
> > wireless-next.  I don't have the time to work through them today,
> > so I'm not pulling.
> > 
> > If you would like to work through the resolution and advise me on
> > how to do it, I'd love to hear about it. :-)
> > 
> > John
> > 
> 
> Cool - I rebased my tree before I read your mail.

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
