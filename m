Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:51322 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757148Ab1BAOiT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 09:38:19 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Feb 2011 06:37:59 -0800
Date: Tue, 1 Feb 2011 20:07:31 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Arend van Spriel <arend@broadcom.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: deauthenticate STAs before suspend
Message-ID: <20110201143730.GA7124@vmraj-lnx.users.atheros.com>
References: <ce260d15f83b54d9a328a2d636cf9a4e@rss.opera.com>
 <op.vp7x6et33ri7v4@arend-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <op.vp7x6et33ri7v4@arend-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 01, 2011 at 03:32:28PM +0530, Arend van Spriel wrote:
> >
> > IOW, I'd rather leave it as is. It seems there isn't really a problem,
> > but rather a perceived inconsistency that is being "fixed"?
> 
> Agree. It may be considered a fix from a particular user-space application
> perspective (ie. NetworkManager) but from standards perspective there is
> no reason to do this.
> 
I have seen this issue as the AP resources are locked for a while, if STA
is not resume back sooner.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
