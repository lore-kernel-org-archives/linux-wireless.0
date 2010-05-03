Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48510 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758761Ab0ECNMF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 09:12:05 -0400
Subject: Re: [PATCH] mac80211: improve IBSS scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20100503T150104-147@post.gmane.org>
References: <1272869388.3614.0.camel@jlt3.sipsolutions.net>
	 <loom.20100503T150104-147@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 15:12:00 +0200
Message-ID: <1272892320.3614.34.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-05-03 at 13:10 +0000, Joerg Pommnitz wrote:
> Johannes Berg <johannes@...> writes:
> > Note that this can be further improved to start
> > the IBSS right away if both frequency and BSSID
> > are fixed.
> 
> Doing this and switching off beaconing would be the same as
> the infamous AH-Demo mode supported by Madwifi and creeping
> into the current kernel, no?

and switching of beaconing. Don't think we want that.

> see http://madwifi-project.org/wiki/UserDocs/AhdemoInterface
> and HTC_M_AHDEMO in enum htc_opmode.
> 
> For me, AH-Demo is required to ditch Madwifi, so are you still
> opposed to its integration? It seems that the pieces of the
> puzzle are almost there now.

WHY is it required for you? And yeah, I _am_ still opposed to that.

johannes

