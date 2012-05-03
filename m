Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eazy.amigager.de ([213.239.192.238]:39222 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab2ECS2Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 14:28:25 -0400
Received: from mac.home (mnch-5d85fab0.pool.mediaWays.net [93.133.250.176])
	by eazy.amigager.de (Postfix) with ESMTPA id CC74EC8C21F
	for <linux-wireless@vger.kernel.org>; Thu,  3 May 2012 20:28:23 +0200 (CEST)
Date: Thu, 3 May 2012 20:28:53 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Power saving features for iwl4965
Message-ID: <20120503182853.GA12461@mac.home> (sfid-20120503_202828_159877_3066A7E0)
References: <20120418203543.GA16000@x61.home>
 <20120425122554.GD2466@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120425122554.GD2466@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 25, 2012 at 14:25:55 +0200, Stanislaw Gruszka wrote:
> On Wed, Apr 18, 2012 at 10:35:43PM +0200, Tino Keitel wrote:
> > up to 2.6.38, the iwl4965 driver was able to use power saving features
> > by invoking "iwconfig <interface> power on", at least when unsetting
> > the broken_powersave variable.
> > 
> > 2.6.39 introduced a new iwlegacy driver for iwl4965 hardware, which was
> > missing power saving.  I was able to port the 2.6.38 driver up to
> > kernel 3.1, but it got too complicated for me with 3.2. 
> > 
> > Are there any plans to fix this power usage regression at some point in
> > the iwlegacy driver? I think there are still a lot of iwl4965 users out
> > there.
> Yes, adding PS support is on my iwlegacy TODO list.

Thanks, I'd be glad if I could help, testing etc.

Regards,
Tino
