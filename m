Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:34511 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751333AbdEDRdd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 May 2017 13:33:33 -0400
MIME-Version: 1.0
In-Reply-To: <20170504.112257.1601480484804301664.davem@davemloft.net>
References: <20170504064230.22058-1-johannes@sipsolutions.net>
 <20170504.111333.814726752020791317.davem@davemloft.net> <1493911002.18881.0.camel@sipsolutions.net>
 <20170504.112257.1601480484804301664.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 4 May 2017 10:33:32 -0700
Message-ID: <CA+55aFzFAjbAzF4Vda6wzSHt+RL4WW3jXfKuXPcFyi8njXJrnQ@mail.gmail.com> (sfid-20170504_193337_527379_9E67CD12)
Subject: Re: [PATCH] cfg80211: make RATE_INFO_BW_20 the default
To: David Miller <davem@davemloft.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 4, 2017 at 8:22 AM, David Miller <davem@davemloft.net> wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
>>
>> I figured I'd give Linus to a chance to try or even apply it, but I
>> have no objection to you applying it either. I don't have anything else
>>   yet right now, and sending a pull request for just a single patch
>> would be quite pointless.
>
> Ok, let's give Linus a chance to test the patch.

I'm having trouble recreating the warning. I have no idea why. It only
happened during ten minutes yesterday, and nothing in my wireless
setup has changed.

I wonder if *normally* my setup ends up connecting with a 40MHz band
or something, and I just happened to see the default uninitialized
case once.

I see that Jens reported that the patch works, although I'm wondering
how repeatable it was for him.  The patch obviously looks simple and
seems like an obviously GoodThing(tm) regardless.

                   Linus
