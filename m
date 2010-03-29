Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:45061 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754453Ab0C2W5d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 18:57:33 -0400
Date: Mon, 29 Mar 2010 15:55:28 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: stable@kernel.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [stable] [PATCH 0/2] ath9k: few stable interrupt fixes
Message-ID: <20100329225528.GC11919@kroah.com>
References: <1268344558-13835-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1268344558-13835-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 11, 2010 at 04:55:56PM -0500, Luis R. Rodriguez wrote:
> Here's a few stable IRQ fixes for ath9k which have already
> been merged upstream. We forgot to add the stable tag on them
> so sending these out manually.
> 
> The patches in this series apply to the latest 2.6.33.y but for
> your convenience I have also backported the patches to the latest
> 2.6.32.y kernel.
> 
> The 2.6.33.y patches can be found here:
> 
> http://kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2010-03/33-fixes/01-ath9k-irq/
> 
> The 2.6.32.y patches can be found here:
> 
> http://kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2010-03/32-fixes/01-ath9k-irq/

Thanks, both sets are now queued up.

greg k-h
