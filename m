Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38345 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751910AbdCCPvK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Mar 2017 10:51:10 -0500
Received: by mail-wm0-f44.google.com with SMTP id t193so18556064wmt.1
        for <linux-wireless@vger.kernel.org>; Fri, 03 Mar 2017 07:50:13 -0800 (PST)
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
Message-ID: <be6446e2-0a39-3b62-a95e-d97739a8bd35@broadcom.com> (sfid-20170303_165207_557804_5A578DF4)
Date: Fri, 3 Mar 2017 13:47:00 +0100
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

Having a day off today so I can wait. Actually made the WPA-PSK change
myself in wpa_supplicant. It is working with brcmfmac. I did not look at
1X yet as I do not have a radius server up and running.

Regards,
Arend
