Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:35909 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752135AbdB1LGr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Feb 2017 06:06:47 -0500
Received: by mail-qk0-f175.google.com with SMTP id n186so12313106qkb.3
        for <linux-wireless@vger.kernel.org>; Tue, 28 Feb 2017 03:06:42 -0800 (PST)
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
Cc: Eliad Peller <eliad@wizery.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <96cd71c3-c279-b298-3876-68bac7297dc4@broadcom.com> (sfid-20170228_120847_719552_6E77406A)
Date: Tue, 28 Feb 2017 12:06:39 +0100
MIME-Version: 1.0
In-Reply-To: <1487677574.2215.4.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21-2-2017 12:46, Johannes Berg wrote:
> 
>>>> Would this work for you? We should have wpa_supplicant support
>>>> too, but need to ask Andrei to look at that.
>>
>> Forgot to reply to this. Yes, this will work. Can come up with
>> wpa_supp changes.
> 
> No, we have them. Just need to see where they are :)

Found anything ? :-p

Gr. AvS
