Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37326 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880Ab2FZNnJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 09:43:09 -0400
Message-ID: <1340718188.14634.47.camel@jlt3.sipsolutions.net> (sfid-20120626_154312_876418_B9036300)
Subject: Re: [RFC v3] initial channel context implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 26 Jun 2012 15:43:08 +0200
In-Reply-To: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>
References: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-26 at 14:37 +0200, Michal Kazior wrote:
> Hi,
> 
> Here's another respin of channel context patches.
> 
> Changes:
> 
>  - moved ieee80211_chan_mode
>  - updated chanctx_conf comment
>  - replaced vif_list with refcount
>  - added lockdeps
>  - channel type downgrading support
>    (when a channel context is unassigned from a vif
>     channel type is recalculated for the remaining vifs
>     sharing the same channel context)

Except for that last point which seems to have implementation issues,
this looks really good too!

How are you planning to proceed from here? I'm happy to pick these up
even if you're not going to work on using it right away since I think in
that case I would probably be working on using it pretty soon, but if
you are planning to work on it that's even better :-)

johannes

