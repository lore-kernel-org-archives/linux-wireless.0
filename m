Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:52835 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932325Ab2CEO2q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 09:28:46 -0500
Received: by mail-ey0-f175.google.com with SMTP id e1so1337893eaa.20
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2012 06:28:27 -0800 (PST)
Message-ID: <4F54CD87.1000505@ti.com> (sfid-20120305_152900_678773_E666282F)
Date: Mon, 05 Mar 2012 16:28:23 +0200
From: Luciano Coelho <coelho@ti.com>
MIME-Version: 1.0
To: Eliad Peller <eliad@wizery.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/11] wl12xx: various patches
References: <1330851355-24459-1-git-send-email-eliad@wizery.com>
In-Reply-To: <1330851355-24459-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/04/2012 10:55 AM, Eliad Peller wrote:
> Some various patches pending in my queue. Mostly
> address issues related to multi-vif and the
> auth/assoc redesign.
>
> Eliad Peller (11):
>    wl12xx: don't start dev role on ibss vifs
>    wl12xx: consider bss_conf->idle instead of hw->conf.flags
>    wl12xx: implement sta_state callback
>    wl12xx: set authorized AP on sta_state notification
>    wl12xx: increment session_counter for device role as well
>    wl12xx: set correct vif type in change_interface callback
>    wl12xx: don't handle change_channel while associated
>    wl12xx: don't allow scanning while device is in ROC
>    wl12xx: configure the correct beacon_interval
>    wl12xx: avoid bug_on_recovery during fw switch
>    wl12xx: print the tx packet len
>
>   drivers/net/wireless/wl12xx/cmd.c    |    2 +-
>   drivers/net/wireless/wl12xx/main.c   |  321 ++++++++++++++--------------------
>   drivers/net/wireless/wl12xx/wl12xx.h |    4 +-
>   3 files changed, 134 insertions(+), 193 deletions(-)

Applied the series, thanks!

-- 
Cheers,
Luca.
