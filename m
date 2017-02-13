Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:38574 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751313AbdBMT1M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Feb 2017 14:27:12 -0500
Received: by mail-wm0-f50.google.com with SMTP id r141so102337452wmg.1
        for <linux-wireless@vger.kernel.org>; Mon, 13 Feb 2017 11:27:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <d53a8fac-b4e0-2fb2-c1e1-c537a2c5e8aa@candelatech.com>
References: <0082a9e3-83f3-9bc3-af43-b890b91cfd93@candelatech.com>
 <1486969571.5142.3.camel@sipsolutions.net> <d53a8fac-b4e0-2fb2-c1e1-c537a2c5e8aa@candelatech.com>
From: Adrian Chadd <adrian@freebsd.org>
Date: Mon, 13 Feb 2017 11:27:10 -0800
Message-ID: <CAJ-Vmo=F22na+nGpbsBjnHfWKG5EGJXM+BQoee_jsZL7y4xLTw@mail.gmail.com> (sfid-20170213_202716_503475_B97FE56B)
Subject: Re: VHT 160Mhz and nss related config.
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.. or give us a legit way to acquire the 2016 spec? :)

Curious implementers want to know!



-a

On 13 February 2017 at 11:21, Ben Greear <greearb@candelatech.com> wrote:
> On 02/12/2017 11:06 PM, Johannes Berg wrote:
>>
>> On Fri, 2017-02-10 at 14:58 -0800, Ben Greear wrote:
>>>
>>> So, it appears that the ath10k QCA9984 4x4 160Mhz chip can do 4x4
>>> MIMO at VHT80, but
>>> it can do only 2x2 MIMO at VHT160/80+80.
>>>
>>> When configuring a peer, we need to tell the firmware the number of
>>> spatial streams
>>> of the peer at VHT160 and at VHT80 and lower.  They are not the same
>>> value.
>>>
>>> I cannot think of any standard way to get this information based on
>>> VHT capabilities and such.  Currently, one could just assume VHT160
>>> NSS is 1/2 of the VHT80 NSS, but that is unlikely to be true for all
>>> vendors.
>>
>>
>> This was recently added to the VHT capabilities in the spec, see Table
>> 9-250 in 802.11-2016.
>>
>> johannes
>>
>
> I don't have that spec...maybe you could post a patch that adds that flag
> and/or other fields to the appropriate header files?  I can attempt to
> add support to ath10k after that...
>
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
