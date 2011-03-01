Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:43602 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971Ab1CAFqt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 00:46:49 -0500
Date: Mon, 28 Feb 2011 19:11:51 -0800
From: Greg KH <greg@kroah.com>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 2/2] staging: brcm80211: Remove unused variables and
 code clean up
Message-ID: <20110301031151.GA7620@kroah.com>
References: <1298840055-5044-1-git-send-email-martinez.javier@gmail.com>
 <1298840055-5044-2-git-send-email-martinez.javier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1298840055-5044-2-git-send-email-martinez.javier@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 27, 2011 at 09:54:15PM +0100, Javier Martinez Canillas wrote:
> tsf_l and tsf_h variables where used in a code segment that is never compiled
> so the variables remains unused. 
> 
> Remove those variables and the code never compiled as well.
> 
> Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
> ---
>  drivers/staging/brcm80211/brcmsmac/wlc_mac80211.c |    9 ---------

This doesn't apply anymore, care to redo it and resend?

thanks,

greg k-h
