Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:44465 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752850Ab2DJKUw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 06:20:52 -0400
Received: by lbom4 with SMTP id m4so3922539lbo.39
        for <linux-wireless@vger.kernel.org>; Tue, 10 Apr 2012 03:20:49 -0700 (PDT)
Message-ID: <1334053247.10398.2.camel@cumari> (sfid-20120410_122055_123603_E091EA2D)
Subject: Re: [PATCH 0/4] wl12xx: various bug fixes for 3.4
From: Luciano Coelho <coelho@ti.com>
To: Eyal Shapira <eyal@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 10 Apr 2012 13:20:47 +0300
In-Reply-To: <1332151589-27272-1-git-send-email-eyal@wizery.com>
References: <1332151589-27272-1-git-send-email-eyal@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-19 at 12:06 +0200, Eyal Shapira wrote: 
> Some recent bug fixes fixing a panic and a memory leak
> related to FW recovery as well as some scan issues.
> 
> Eyal Shapira (4):
>   wl12xx: fix race between suspend/resume and recovery
>   wl12xx: fix a memory leak of probereq template upon recovery
>   wl12xx: adaptive sched scan dwell times
>   wl12xx: increase scan timeout to 30s
> 
>  drivers/net/wireless/wl12xx/conf.h |   28 ++++++++++++++----
>  drivers/net/wireless/wl12xx/main.c |   54 +++++++++++++++++++----------------
>  drivers/net/wireless/wl12xx/scan.c |   29 ++++++++++++++++--
>  drivers/net/wireless/wl12xx/scan.h |    2 +-
>  4 files changed, 77 insertions(+), 36 deletions(-)

Pushed the series, except for 1/4 because it was duplicate.

-- 
Cheers,
Luca.

