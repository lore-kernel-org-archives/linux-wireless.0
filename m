Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54915 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1A1NRq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 08:17:46 -0500
Subject: Re: Multiple vifs and HT v/s non-HT.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4D41FACB.2010807@candelatech.com>
References: <4D41FACB.2010807@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 14:17:43 +0100
Message-ID: <1296220663.5118.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-01-27 at 15:07 -0800, Ben Greear wrote:
> We found something fun while playing with HT mode:
> 
> We had some vifs associated with an AP with HT enabled,
> and other VIFS to an AP with HT disabled.
> 
> They managed to associate, but with slow rates and
> for whatever reason, nothing is able to send traffic.
> I would have expected one set or the other would
> be able to send traffic.
> 
> The ath9k hardware ended up in HT mode according to
> ath9k debugfs wiphy file, but that was probably
> just luck.
> 
> I'm not too sure how to ensure this mixed-mode HT
> scenario doesn't happen at this point...

So that patch you sent addressed this?

johannes

