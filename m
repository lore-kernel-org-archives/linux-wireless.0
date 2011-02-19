Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45169 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab1BSJZW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Feb 2011 04:25:22 -0500
Received: by fxm20 with SMTP id 20so4673736fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Feb 2011 01:25:21 -0800 (PST)
Date: Sat, 19 Feb 2011 12:25:17 +0300
From: Stanislav Fomichev <kernel@fomichev.me>
To: Greg KH <greg@kroah.com>
Cc: brudley@broadcom.com, gregkh@suse.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] brcm80211: fix warnings in wl_check_firmwares
Message-ID: <20110219092422.GA1828@sdf-MacBook>
References: <20110212174700.GA2058@sdf-MacBook>
 <20110218205731.GD796@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110218205731.GD796@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Sat, Feb 12, 2011 at 08:47:00PM +0300, Stanislav Fomichev wrote:
> > Use %zu instead of %d for size_t
> > 
> > Signed-off-by: Stanislav Fomichev <kernel@fomichev.me>
> > ---
> >  drivers/staging/brcm80211/sys/wl_mac80211.c |    4 ++--
> 
> This doesn't apply to linux-next as this file isn't around anymore :(
This is not relevant anymore as I see you included the other patch with
the same title (which is based on the right tree).

-- 
	Stas
