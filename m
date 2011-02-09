Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:53895 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab1BITsw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 14:48:52 -0500
Date: Wed, 9 Feb 2011 11:45:56 -0800
From: Greg KH <greg@kroah.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Jason Cooper <jason@lakedaemon.net>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Arend van Spriel <arend@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>, trivial@kernel.org
Subject: Re: [PATCH][trivial] Remove duplicate inclusion of wlc_event.h in
 drivers/staging/brcm80211/sys/wlc_mac80211.c
Message-ID: <20110209194556.GA30200@kroah.com>
References: <alpine.LNX.2.00.1102062249180.13593@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.LNX.2.00.1102062249180.13593@swampdragon.chaosbits.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 06, 2011 at 10:52:17PM +0100, Jesper Juhl wrote:
> We include wlc_event.h twice in 
> drivers/staging/brcm80211/sys/wlc_mac80211.c
> Once is enough.

Odd, this file isn't even in the linux-next tree anymore, what tree did
you make this against?

thanks,

greg k-h
