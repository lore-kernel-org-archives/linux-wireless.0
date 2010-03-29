Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:57323 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258Ab0C2XOq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 19:14:46 -0400
Date: Mon, 29 Mar 2010 16:09:36 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: stable@kernel.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [stable] [PATCH 0/2] mac80211: stable fixes for UDP packet
	loss when enabling power save
Message-ID: <20100329230936.GD11919@kroah.com>
References: <1268344623-22076-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1268344623-22076-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 11, 2010 at 04:57:01PM -0500, Luis R. Rodriguez wrote:
> Here's a few stable fixes for mac80211/ath9k which have already
> been merged upstream. We forgot to add the stable tag on them
> so sending these out manually. The patches address an issue of packet
> loss when going into power save mode.
> 
> The patches in this series apply to the latest 2.6.33.y but for
> your convenience I have also backported the patches to the latest
> 2.6.32.y kernel.
> 
> The 2.6.33.y patches can be found here:
> 
> http://kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2010-03/33-fixes/02-mac80211-udp-ps-issue/
> 
> The 2.6.32.y patches can be found here:
> 
> http://kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2010-03/32-fixes/02-mac80211-udp-ps-issue/

Now queued up.

thanks,

greg k-h
