Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4811 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428Ab0EaNDr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 May 2010 09:03:47 -0400
Date: Mon, 31 May 2010 08:56:40 -0400
From: me@bobcopeland.com
To: Peter Chubb <peter.chubb@nicta.com.au>
Cc: Bruno Randolf <br1@einfach.org>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: Commit 6b5d,.. breaks ath5k in WPA-enabled networks
Message-ID: <20100531125640.GA11680@hash.localnet>
References: <w47hmkh1b4.wl%peter@chubb.wattle.id.au> <201005311926.34371.br1@einfach.org> <w4mxvg2tz0.wl%peter@chubb.wattle.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <w4mxvg2tz0.wl%peter@chubb.wattle.id.au>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 31, 2010 at 09:25:55PM +1000, Peter Chubb wrote:
> Bruno> On Monday 31 May 2010 18:23:43 Peter Chubb wrote:
> >> With Linus's current head-of-tree my ath5k cannot associate with
> >> WPA-enabled access points.  I bisected back to this patch:
> >> 
> >> Since commit 6b5d117eddc09cd976ad8030d715f4350f598a22 ath5k: clean
> >> up queue manipulation
> 
> Bruno> try this, please:
> Bruno> https://patchwork.kernel.org/patch/100681/
> 
> This works, thanks.

Yeah, big oops. :\

So what do we do now?  I guess we should just revert it for now rather
than taking the half that works plus Bruno's fix?

-- 
Bob Copeland %% www.bobcopeland.com

