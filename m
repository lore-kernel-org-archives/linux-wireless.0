Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:40937 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754309Ab2BOKVH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 05:21:07 -0500
Received: by mail-lpp01m010-f41.google.com with SMTP id f4so1018324lam.14
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2012 02:21:06 -0800 (PST)
Message-ID: <1329301263.19569.46.camel@cumari> (sfid-20120215_112111_776282_884F8E5D)
Subject: Re: [PATCH 0/4] wl12xx: some scan patches
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 15 Feb 2012 12:21:03 +0200
In-Reply-To: <1328183669-21059-1-git-send-email-eliad@wizery.com>
References: <1328183669-21059-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-02 at 13:54 +0200, Eliad Peller wrote: 
> fix some various scan issues
> 
> Eliad Peller (1):
>   wl12xx: don't fail on AP scan
> 
> Eyal Shapira (2):
>   wl12xx: use split scan for normal scan
>   wl12xx: add split_scan_timeout debugfs file
> 
> Ido Reis (1):
>   wl12xx: increase max probe-req template size to
>     WL1271_CMD_TEMPL_MAX_SIZE
> 
>  drivers/net/wireless/wl12xx/conf.h    |    8 ++++++
>  drivers/net/wireless/wl12xx/debugfs.c |   43 +++++++++++++++++++++++++++++++++
>  drivers/net/wireless/wl12xx/init.c    |    4 +-
>  drivers/net/wireless/wl12xx/main.c    |    5 ++-
>  drivers/net/wireless/wl12xx/scan.c    |   21 +++++++++-------
>  drivers/net/wireless/wl12xx/scan.h    |    2 +-
>  6 files changed, 69 insertions(+), 14 deletions(-)

Applied these 4 patches, thanks!


-- 
Cheers,
Luca.

