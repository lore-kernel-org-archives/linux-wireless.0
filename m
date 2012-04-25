Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab2DYMZ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 08:25:27 -0400
Date: Wed, 25 Apr 2012 14:25:55 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Tino Keitel <tino.keitel@tikei.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Power saving features for iwl4965
Message-ID: <20120425122554.GD2466@redhat.com> (sfid-20120425_142546_939665_A89EE73D)
References: <20120418203543.GA16000@x61.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120418203543.GA16000@x61.home>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 18, 2012 at 10:35:43PM +0200, Tino Keitel wrote:
> up to 2.6.38, the iwl4965 driver was able to use power saving features
> by invoking "iwconfig <interface> power on", at least when unsetting
> the broken_powersave variable.
> 
> 2.6.39 introduced a new iwlegacy driver for iwl4965 hardware, which was
> missing power saving.  I was able to port the 2.6.38 driver up to
> kernel 3.1, but it got too complicated for me with 3.2. 
> 
> Are there any plans to fix this power usage regression at some point in
> the iwlegacy driver? I think there are still a lot of iwl4965 users out
> there.
Yes, adding PS support is on my iwlegacy TODO list.

Stanislaw
