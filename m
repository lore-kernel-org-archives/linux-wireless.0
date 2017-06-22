Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:55366 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751927AbdFVOnG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 10:43:06 -0400
Subject: Re: [RFC 3/6] mac80211: add a TXQ for other powersave-buffered frames
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170621235022.25362-1-johannes@sipsolutions.net>
 <20170621235022.25362-3-johannes@sipsolutions.net>
 <63c97c53-af93-107a-a28e-59cebcf01fd6@candelatech.com>
 <1498112650.2246.1.camel@sipsolutions.net>
Cc: nbd@nbd.name
From: Ben Greear <greearb@candelatech.com>
Message-ID: <3735eb1d-89b5-b4ad-6657-d0d4e9642574@candelatech.com> (sfid-20170622_164309_380353_D02C5192)
Date: Thu, 22 Jun 2017 07:43:04 -0700
MIME-Version: 1.0
In-Reply-To: <1498112650.2246.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/21/2017 11:24 PM, Johannes Berg wrote:
> On Wed, 2017-06-21 at 17:02 -0700, Ben Greear wrote:
>> I think a comment for the above code block would be warranted (and
>> for ath10k as well).
>>
>> I guess this is the part about dequeueing the frames immediately?
>
> Yeah, I figured it was pretty obvious, but I can add a comment :)

It is fairly obvious today, but 6 months from now when someone tries yet again
to figure out WTF is ath10k doing, it will be one more piece of mystery code!

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
