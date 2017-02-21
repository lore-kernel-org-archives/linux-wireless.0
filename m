Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:35692 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752100AbdBULyv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 06:54:51 -0500
Received: by mail-wr0-f179.google.com with SMTP id s27so33670551wrb.2
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2017 03:54:50 -0800 (PST)
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
Message-ID: <a55ccdc2-a8d5-90a3-407c-e9b545c7f446@broadcom.com> (sfid-20170221_125706_755419_C53C4C52)
Date: Tue, 21 Feb 2017 12:54:48 +0100
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

I see. Will keep an eye on hostapd list ;-)

Gr. AvS
