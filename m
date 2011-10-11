Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:42731 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753398Ab1JKNUd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 09:20:33 -0400
Received: by mail-bw0-f43.google.com with SMTP id s6so14056928bka.16
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 06:20:32 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: move debugging definitions to a separate file
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1318085047.9690.32.camel@cumari>
References: <1317975194-18306-1-git-send-email-coelho@ti.com>
	 <1318085047.9690.32.camel@cumari>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 16:20:22 +0300
Message-ID: <1318339222.9690.524.camel@cumari> (sfid-20111011_152036_362240_CD0F0306)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-10-08 at 17:44 +0300, Luciano Coelho wrote: 
> On Fri, 2011-10-07 at 11:13 +0300, Luciano Coelho wrote: 
> > Separate the debugging macros and other definitions to a new debug.h
> > file.  This is be needed because the sdio and spi modules don't need
> > to depend on the wl12xx module anymore, but still need to include
> > wl12xx.h.  Currently they do depend on it, because of the debugging
> > global that wl12xx exports.  A future patch will remove this
> > dependency.
> > 
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
> > ---
> 
> These defines should be in debug.h as well:
> 
> #define DRIVER_NAME "wl1271"
> #define DRIVER_PREFIX DRIVER_NAME ": "
> 
> I'll move them too and rename wl1271 to wl12xx when I apply.

Applied.

-- 
Cheers,
Luca.

