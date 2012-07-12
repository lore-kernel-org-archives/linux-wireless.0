Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46845 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758250Ab2GLMl1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 08:41:27 -0400
Message-ID: <1342096884.4531.19.camel@jlt3.sipsolutions.net> (sfid-20120712_144138_627451_75F92EB3)
Subject: Re: pull-request: mac80211-next 2012-07-12
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 12 Jul 2012 14:41:24 +0200
In-Reply-To: <1342088129.4531.16.camel@jlt3.sipsolutions.net> (sfid-20120712_121541_700966_1EAF6065)
References: <1341946090.4475.31.camel@jlt3.sipsolutions.net>
	 (sfid-20120710_204821_128762_BC016001) <1342088129.4531.16.camel@jlt3.sipsolutions.net>
	 (sfid-20120712_121541_700966_1EAF6065)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-07-12 at 12:15 +0200, Johannes Berg wrote:
> John,
> 
> Here's a fixed pull request, please take this version. I've included the
> fixed version of the API additions/updates for the P2P Device
> abstraction, I still don't know if we'll get the actual code done in
> time for 3.6 but I didn't want to hang on to these APIs for too long to
> avoid conflicts.
> 
> I've also included some more fixes for the multi-channel and 60GHz work
> as well as a few other fixes.
> 
> The "iterate monitor interfaces patch" is new over the previous version
> of the pull request.
> 
> Thanks,
> Johannes
> 
> The following changes since commit 4d6d0ae2a088e1e054ef6d96ceb1b41523291e71:
> 
>   mac80211_hwsim: add testmode code to stop/wake queues (2012-07-06 15:27:15 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git 

Hmm. This doesn't call out the "for-john" branch for some reason? Not
sure why that happened.

johannes

