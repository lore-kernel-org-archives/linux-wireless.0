Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:37397 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751507AbeCVKoQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Mar 2018 06:44:16 -0400
Received: by mail-qk0-f196.google.com with SMTP id w6so8627419qkb.4
        for <linux-wireless@vger.kernel.org>; Thu, 22 Mar 2018 03:44:16 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: Add timestamp to scan results report
To: dimitrysh@google.com, linux-wireless@vger.kernel.org
References: <00000000000080af470567f3ef29@google.com>
Cc: johannes@sipsolutions.net, franky.lin@broadcom.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AB388FE.2040609@broadcom.com> (sfid-20180322_114438_260745_7333AABF)
Date: Thu, 22 Mar 2018 11:44:14 +0100
MIME-Version: 1.0
In-Reply-To: <00000000000080af470567f3ef29@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/21/2018 11:44 PM, dimitrysh@google.com wrote:
>  From 01da9ee11ce6e0973972b2ffd37eef660714f71a Mon Sep 17 00:00:00 2001
> From: Dmitry Shmidt <dimitrysh@google.com>
> Date: Wed, 21 Mar 2018 15:35:45 -0700
> Subject: [PATCH] brcmfmac: Add timestamp to scan results report
>
> Monotonic time from boot is good timestamp indicator
> and it can be used by kernel and userspace.

Thanks, Dmitry

I recall a similar attempt for another driver, but I think the timestamp 
should really be the TSF of the beacon/proberesp received. As you 
already Cc-ed Johannes explicitly maybe he can clarify what is needed 
here as I do not recall the details. ;-)

Regards,
Arend

> Change-Id: I122374fa79c6dbd7967b2c30553cb04dee032ebc
> Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
