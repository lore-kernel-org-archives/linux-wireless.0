Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:53362 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab1BRVER (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 16:04:17 -0500
Date: Fri, 18 Feb 2011 12:58:15 -0800
From: Greg KH <greg@kroah.com>
To: Stanislav Fomichev <kernel@fomichev.me>
Cc: linux-wireless@vger.kernel.org, brudley@broadcom.com,
	gregkh@suse.de
Subject: Re: [PATCH 1/8] brcm80211: replace dot11_header with ieee80211_hdr
Message-ID: <20110218205815.GE796@kroah.com>
References: <1297608043-18381-1-git-send-email-kernel@fomichev.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297608043-18381-1-git-send-email-kernel@fomichev.me>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 13, 2011 at 05:40:36PM +0300, Stanislav Fomichev wrote:
> This is a series of patches which remove brcm specific definitions.
> Tested on MacBook 7.1.
> 
> Signed-off-by: Stanislav Fomichev <kernel@fomichev.me>
> ---
>  drivers/staging/brcm80211/include/proto/802.11.h |   10 ----
>  drivers/staging/brcm80211/sys/wlc_ampdu.c        |   18 +++---
>  drivers/staging/brcm80211/sys/wlc_mac80211.c     |   64 +++++++++++-----------

You really need to do this against linux-next, as I can't apply any of
these patches.

Care to respin them and resend?

thanks,

greg k-h
