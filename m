Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:36256 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdCRHIk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Mar 2017 03:08:40 -0400
Received: by mail-wr0-f172.google.com with SMTP id u108so63806895wrb.3
        for <linux-wireless@vger.kernel.org>; Sat, 18 Mar 2017 00:08:11 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: support 4-way handshake offloading for
 WPA/WPA2-PSK
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170221100957.30965-1-johannes@sipsolutions.net>
 <231f969e-eac1-3196-07c2-80e37e6dda55@broadcom.com>
 <1487673603.2215.3.camel@sipsolutions.net>
 <c38019e8-32b5-5fa2-1da7-8022cbb62b13@broadcom.com>
 <a021dbf9-854d-0339-b87d-b27b746ccd1b@broadcom.com>
 <1487677574.2215.4.camel@sipsolutions.net>
 <96cd71c3-c279-b298-3876-68bac7297dc4@broadcom.com>
 <1488543681.25750.3.camel@sipsolutions.net>
 <5f34db3e-1d68-71aa-07b2-5296eaa9f533@broadcom.com>
 <1489499543.10872.5.camel@sipsolutions.net>
Cc: Eliad Peller <eliad@wizery.com>,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Avraham Stern <avraham.stern@intel.com>,
        Jouni Malinen <j@w1.fi>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <ca6266ba-d399-5ea3-2faf-a4271025179f@broadcom.com> (sfid-20170318_080902_970540_EDD250F9)
Date: Sat, 18 Mar 2017 08:08:09 +0100
MIME-Version: 1.0
In-Reply-To: <1489499543.10872.5.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Jouni

On 14-3-2017 14:52, Johannes Berg wrote:
> 
>> So the 4-way hs offload patches in wpa_s RFC do not make distinction
>> between 1X and WPA-PSK. Can we expect drivers to support one, but not
>> the other? In other words do we need the flexibility in nl80211?
> 
> You tell me :)
> 
> We're implementing both. Andrei also raised this question on the wpa_s
> patches at my request, and nobody commented.

I see. For our firmware we can also implement both.

> I can live with combining them, but nobody better complain about it
> when they just implement one of them on their device ... :)

Indeed. These are two different use-cases so I can see merit in making
the distinction. However, for those implementing just one it would be
nice to have the distinction between 1X and WPA-PSK offload support in
wpa_supplicant as well.

Regards,
Arend
