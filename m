Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eazy.amigager.de ([213.239.192.238]:47602 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab2JAQPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 12:15:23 -0400
Received: from mac.home (mnch-5d85f266.pool.mediaWays.net [93.133.242.102])
	by eazy.amigager.de (Postfix) with ESMTPA id 2D369C8C03F
	for <linux-wireless@vger.kernel.org>; Mon,  1 Oct 2012 18:06:40 +0200 (CEST)
Date: Mon, 1 Oct 2012 18:06:52 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Power saving features for iwl4965
Message-ID: <20121001160652.GA24174@mac.home> (sfid-20121001_181527_959126_D8254EA7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hi,

is there any progress regarding this? I didn't see something obvious in
the git log.

Regards,
Tino
