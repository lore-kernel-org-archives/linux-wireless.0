Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:50946 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752292Ab1HYHZ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 03:25:27 -0400
Received: by bkbzs2 with SMTP id zs2so2570059bkb.39
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 00:25:24 -0700 (PDT)
Subject: Re: [PATCH 0/2] wl12xx: some improvements in scheduled scan support
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1314113685-27437-1-git-send-email-coelho@ti.com>
References: <1314113685-27437-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Aug 2011 10:25:21 +0300
Message-ID: <1314257121.2296.251.camel@cumari> (sfid-20110825_092532_789312_0775862B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-23 at 18:34 +0300, Luciano Coelho wrote: 
> Hi,
> 
> Here are a couple of patches to improve support for scheduled scan in wl12xx.
> With these patches we add support for more than one SSID in scheduled scans.
> 
> Cheers,
> Luca.
> 
> Luciano Coelho (2):
>   wl12xx: add support for multiple SSIDs in sched_scan
>   wl12xx: use SCAN_SSID_TYPE_PUBLIC when using the wildcard in
>     sched_scan
> 
>  drivers/net/wireless/wl12xx/main.c |    2 +-
>  drivers/net/wireless/wl12xx/scan.c |   66 ++++++++++++++++++++++++++++++++----
>  2 files changed, 60 insertions(+), 8 deletions(-)

Applied this series.

-- 
Cheers,
Luca.

