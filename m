Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:33303 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932275AbdCINjD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Mar 2017 08:39:03 -0500
Received: by mail-qk0-f181.google.com with SMTP id y76so118909820qkb.0
        for <linux-wireless@vger.kernel.org>; Thu, 09 Mar 2017 05:39:02 -0800 (PST)
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
Cc: Eliad Peller <eliad@wizery.com>,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Avraham Stern <avraham.stern@intel.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5f34db3e-1d68-71aa-07b2-5296eaa9f533@broadcom.com> (sfid-20170309_143923_955802_81AF5668)
Date: Thu, 9 Mar 2017 14:38:54 +0100
MIME-Version: 1.0
In-Reply-To: <1488543681.25750.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3-3-2017 13:21, Johannes Berg wrote:
> On Tue, 2017-02-28 at 12:06 +0100, Arend Van Spriel wrote:
>> On 21-2-2017 12:46, Johannes Berg wrote:
>>>
>>>>>> Would this work for you? We should have wpa_supplicant
>>>>>> support
>>>>>> too, but need to ask Andrei to look at that.
>>>>
>>>> Forgot to reply to this. Yes, this will work. Can come up with
>>>> wpa_supp changes.
>>>
>>> No, we have them. Just need to see where they are :)
>>
>> Found anything ? :-p
> 
> Sorry, got too busy with other stuff.
> 
> +Andrei, can you send out the patches from Avi in wpa_s for doing the
> 4-way-HS offload (as an RFC)?
> 
> Arend, wait a bit - he's travelling now I think.

So the 4-way hs offload patches in wpa_s RFC do not make distinction
between 1X and WPA-PSK. Can we expect drivers to support one, but not
the other? In other words do we need the flexibility in nl80211?

Regards,
Arend
