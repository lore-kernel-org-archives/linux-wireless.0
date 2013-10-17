Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44013 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab3JQOa5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 10:30:57 -0400
Message-ID: <1382020249.14410.7.camel@jlt4.sipsolutions.net> (sfid-20131017_163109_928773_BDA8A656)
Subject: Re: [PATCH] mac80211: fixes for mesh powersave logic
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Thu, 17 Oct 2013 16:30:49 +0200
In-Reply-To: <1381832964-3684-1-git-send-email-marco@cozybit.com> (sfid-20131015_122948_077345_6C4E933A)
References: <1381832964-3684-1-git-send-email-marco@cozybit.com>
	 (sfid-20131015_122948_077345_6C4E933A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-10-15 at 12:29 +0200, Marco Porsch wrote:
> This patch fixes errors in the mesh powersave logic which
> cause that remote peers do not get peer power mode change
> notifications and mesh peer service periods (MPSPs) got
> stuck.
> 
> When closing a peer link, set the (now invalid) peer-specific
> power mode to 'unknown'.
> 
> Avoid overhead when local power mode is unchanged.
> 
> Reliably clear MPSP flags on peering status update.
> 
> Avoid MPSP flags getting stuck by not requesting a further
> MPSP ownership if we already are an MPSP owner.

Applied to -next, there are too many unimportant and unrelated changes
in this patch for me to send it to 3.12 at this point.

johannes

