Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:53359 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867Ab1BRVEQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 16:04:16 -0500
Date: Fri, 18 Feb 2011 12:57:31 -0800
From: Greg KH <greg@kroah.com>
To: Stanislav Fomichev <kernel@fomichev.me>, brudley@broadcom.com,
	gregkh@suse.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] brcm80211: fix warnings in wl_check_firmwares
Message-ID: <20110218205731.GD796@kroah.com>
References: <20110212174700.GA2058@sdf-MacBook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110212174700.GA2058@sdf-MacBook>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 12, 2011 at 08:47:00PM +0300, Stanislav Fomichev wrote:
> Use %zu instead of %d for size_t
> 
> Signed-off-by: Stanislav Fomichev <kernel@fomichev.me>
> ---
>  drivers/staging/brcm80211/sys/wl_mac80211.c |    4 ++--

This doesn't apply to linux-next as this file isn't around anymore :(

thanks,

greg k-h
