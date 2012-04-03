Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43801 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab2DCNyv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 09:54:51 -0400
Received: by wgbdr13 with SMTP id dr13so3766266wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Apr 2012 06:54:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmok1qzkHVhJescbuEwz8OzfeqpHg5RC=vk4XA1KEqAGeKQ@mail.gmail.com>
References: <CAJ8GFOihCt_JBPoawk2xKOO6wan_03F9LLwhsOAbmAKXSs0ygg@mail.gmail.com>
	<CAJ-Vmok1qzkHVhJescbuEwz8OzfeqpHg5RC=vk4XA1KEqAGeKQ@mail.gmail.com>
Date: Tue, 3 Apr 2012 08:54:49 -0500
Message-ID: <CAJ8GFOi0LjAE+tFAQtwYeiiUj=STSRfOh8p+4vkTmk-aJqP31w@mail.gmail.com> (sfid-20120403_155454_679348_9347F5FA)
Subject: Re: Dual-band support for AP mode for AR9280?
From: Harshal Chhaya <harshal@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adrian,

Thanks for your response.

On Fri, Mar 30, 2012 at 9:01 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> On 30 March 2012 14:04, Harshal Chhaya <harshal@gmail.com> wrote:
>> Hello,
>>
>> The 'ath9k' project page
>> (http://linuxwireless.org/en/users/Drivers/ath9k) mentions that '2x2
>> DB 11n' operation is supported for AR9280. A later section says that
>> 'AP mode' is supported.
>
> These are both true.

Good - thanks for the confirmation.

Does ath9k already support DFS?

>> Does the AP mode support full 11n features in a dual-band
>> configuration? Is there a hard limit to the number of clients when the
>> AR9280 is used as an AP? I am currently using an AR9170 (using
>> carl9170 - thanks, Christian) as an AP and found that I had to switch
>> to software encryption to scale beyond 32 clients because of the
>> number of key slots on the chip.
>
> Yes. It's a dual band chip, but you only get to choose one band at a time.

That's good to know - concurrent dual-band operation isn't a very
important feature for me so this isn't a big problem.


> Yes, there are limited keycache slot chips. I don't remember if the
> hardware limit is 32 or 64 clients.

Do you know if I can disable hw encryption and do only s/w encryption
with ath9k? I realize that there may be a performance impact but I am
willing to sacrifice some performance if I can support more clients.


>> And are the numbers in the 'power consumption' analysis
>> (http://linuxwireless.org/en/users/Drivers/ath9k/power-consumption)
>> for STA mode or AP mode? The 'PS On' configuration implies that this
>> is for an STA mode but I wanted to confirm.
>
> You should always do your own power consumption tests. It differs
> based on operating mode, environment, TX rate selection/power, what
> kind of amplifiers and other circuitry are on the NIC, etc.

Good point - we will certainly do the power measurements on our own
board but I was curious about the power numbers published on the
website. Since our design is power-constrained I wanted to check if
AR9280 is even an option before we start designing boards.

Thanks for the help.

Regards,
- Harshal


> Adrian
