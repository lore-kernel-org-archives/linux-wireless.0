Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:49155 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751845AbaEONSU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 09:18:20 -0400
Message-ID: <1400159890.4521.21.camel@dubbel> (sfid-20140515_151823_519752_2F4D4269)
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com,
	andrei.otcheretianski@intel.com
Date: Thu, 15 May 2014 16:18:10 +0300
In-Reply-To: <1400159466.4146.4.camel@jlt4.sipsolutions.net>
References: <1399633911-12788-1-git-send-email-luca@coelho.fi>
	 <1400159466.4146.4.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 0/8] mac80211/cfg80211/iwlwifi: a few channel-switch
 patches
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-15 at 15:11 +0200, Johannes Berg wrote:
> On Fri, 2014-05-09 at 14:11 +0300, Luca Coelho wrote:
> > From: Luciano Coelho <luciano.coelho@intel.com>
> > 
> > Hi,
> > 
> > These are a few channel-switch patches by Andrei that we have in our
> > internal tree.  I have rebased them for upstream.
> 
> Applied the cfg80211/mac80211 changes, but please ... that cover letter
> was useless,

Yes, it was a bit useless in terms of content, but I like to group
things and reckoned it would be nice to explain why I was sending
Andrei's patches.  Also, I like the fact that you can reply to the cover
letter saying that you applied everything (or not) instead of replying
to one of the actual patches (say 1/8).

>  and your patch set had build breakage in the middle. :)

Oh, really? Sorry about that... I probably screwed up the rebase...

> I fixed that with along with some minor editing changes and a change to
> the netlink dump as well.

Thanks!

Maybe next time I should not volunteer to send other people's patches
upstream.  I do enough breakage with my own stuff! :P

--
Luca.

