Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:53355 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab1BRVEO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 16:04:14 -0500
Date: Fri, 18 Feb 2011 12:57:00 -0800
From: Greg KH <greg@kroah.com>
To: Stanislav Fomichev <kernel@fomichev.me>, brudley@broadcom.com,
	gregkh@suse.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] brcm80211: remove multiple calls to wl_release_fw
Message-ID: <20110218205700.GC796@kroah.com>
References: <20110212150033.GA1941@sdf-MacBook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110212150033.GA1941@sdf-MacBook>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 12, 2011 at 06:00:33PM +0300, Stanislav Fomichev wrote:
> This causes an oops when the bcm43xx_hdr-0.fw binary is not found.
> 
> Signed-off-by: Stanislav Fomichev <s@fomichev.me>
> ---
>  drivers/staging/brcm80211/sys/wl_mac80211.c |    2 --

This doesn't apply on linux-next, what tree is it supposed to be for?

confused,

greg k-h
