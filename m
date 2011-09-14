Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:33234 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755783Ab1INJZM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 05:25:12 -0400
Received: by mail-bw0-f47.google.com with SMTP id 11so1758346bke.34
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2011 02:25:11 -0700 (PDT)
Subject: Re: [PATCH 0/3] wl12xx: add support for SSID matching in sched_scan
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1314962903-29574-1-git-send-email-coelho@ti.com>
References: <1314962903-29574-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 12:25:03 +0300
Message-ID: <1315992303.2498.80.camel@cumari> (sfid-20110914_112515_414592_5658B228)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-09-02 at 14:28 +0300, Luciano Coelho wrote: 
> Hi,
> 
> This patchset adds support for SSID matching (ie. filtering) on
> scheduled scans.  I have also increased the number of supported SSIDs,
> because recent versions of the firmware support 16 SSIDs at once.
> 
> Due to the increased number of SSIDs supported, I also had to increase
> the dwell times for the scheduled scan.  I used large arbitrary values
> that work fine for now, but they should probably be fine-tuned later.
> 
> This patchset depends on "nl80211/cfg80211: add match filtering for
> sched_scan".
> 
> Please review.
> 
> Cheers,
> Luca.
> 
> 
> Luciano Coelho (3):
>   wl12xx: add support for sched_scan filters
>   wl12xx: increase number of allowed SSIDs in sched_scan
>   wl12xx: ignore sched scan match sets without SSID
> 
>  drivers/net/wireless/wl12xx/main.c |    7 +-
>  drivers/net/wireless/wl12xx/scan.c |  116 +++++++++++++++++++++++++-----------
>  2 files changed, 85 insertions(+), 38 deletions(-)

Applied the series, thank me. :)

-- 
Cheers,
Luca.

