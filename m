Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lj1-f177.google.com ([209.85.208.177]:39721 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbeHUMWw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 08:22:52 -0400
Received: by mail-lj1-f177.google.com with SMTP id l15-v6so13717617lji.6
        for <linux-wireless@vger.kernel.org>; Tue, 21 Aug 2018 02:03:32 -0700 (PDT)
Subject: Re: [RFC] cfg80211: let's wmm_rule be part of reg_rule structure
To: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
References: <20180821074020.GA28952@redhat.com>
 <7580e821-bfa0-e4d4-435f-a042b0eba555@gmail.com>
 <1534841913.25523.0.camel@sipsolutions.net>
From: =?UTF-8?Q?Grzegorz_Duszy=c5=84ski?= <gfduszynski@gmail.com>
Message-ID: <e8256351-be77-0915-1d6c-179a6296c7a1@gmail.com> (sfid-20180821_110335_691150_49CF6C3A)
Date: Tue, 21 Aug 2018 11:03:29 +0200
MIME-Version: 1.0
In-Reply-To: <1534841913.25523.0.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21.08.2018 10:58, Johannes Berg wrote:
> On Tue, 2018-08-21 at 10:57 +0200, Grzegorz Duszyński wrote:
>> I've just briefly tested it, looks like it's working!
>> I have only remote access to my machine at the moment so it's difficult
>> to say for sure if everything is in order.
>> However stalls do not occur, nor there are any error/warnings anywhere.
>>
> That probably just means you now have some invalid data somewhere,
> rather than a crash... Not sure which is better - I guess you'd rather
> have it not crash, and I'd rather figure out where the invalid data is
> coming from :)
>
> johannes

Definitely better than crash :D
Since now if something goes south I'll have a chance to reboot without 
powercycling.

Just to clarify, I was testing patch submitted by Stanisław this morning.
