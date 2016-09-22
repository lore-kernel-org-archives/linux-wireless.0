Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41092 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751365AbcIVESv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 00:18:51 -0400
Message-ID: <57E35BA9.7050207@candelatech.com> (sfid-20160922_061855_014771_11769471)
Date: Wed, 21 Sep 2016 21:18:49 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: bruce m beach <brucembeach@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath9k_htc kernel driver regression affecting throughput
References: <CAArymCks5NN=09EdJ4uaoRrHZciYAkYTES+i62BkfZ4R-W30HQ@mail.gmail.com> <96b0636d-1171-5830-6481-edb991ca8e1a@rempel-privat.de> <CAArymCnJZgUbgCiLqA6-94RAtXYkYeeS9uF71MX9+ou-AbYszg@mail.gmail.com>
In-Reply-To: <CAArymCnJZgUbgCiLqA6-94RAtXYkYeeS9uF71MX9+ou-AbYszg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 09/21/2016 08:34 PM, bruce m beach wrote:

>>> i.e a lable that the code jumps to and nothing else. At this point I have
>>> added VendorCommand(), and a debugger via ep0. ( ep0 is a good choice
>>> since it is available a boot, no matter what) and over the next few
>>> months I am going to move ->all<- the rom code into ram starting with
>>> the USB subsystem.

Have you investigated whether you have enough RAM to do this?

I haven't looked at ath9k_htc, but in general, that type of architecture
is tight on RAM in my experience.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
