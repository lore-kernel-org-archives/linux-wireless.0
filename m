Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60454 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751179AbeC0OJV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 10:09:21 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Izzy Kulbe <kernel@unikorn.me>
Cc: luciano.coelho@intel.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: add device ID for Rivet Networks Killer Wireless-AC 1550
References: <1522148065.12122.5.camel@unikorn.me>
        <87370lrb7y.fsf@kamboji.qca.qualcomm.com>
        <2c826451177bbcb8fe033631dc7b87eb92f5e42d.camel@unikorn.me>
Date: Tue, 27 Mar 2018 17:09:17 +0300
In-Reply-To: <2c826451177bbcb8fe033631dc7b87eb92f5e42d.camel@unikorn.me> (Izzy
        Kulbe's message of "Tue, 27 Mar 2018 14:03:31 +0200")
Message-ID: <87y3idpq42.fsf@kamboji.qca.qualcomm.com> (sfid-20180327_160933_630723_0E690451)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Izzy Kulbe <kernel@unikorn.me> writes:

> On Tue, 2018-03-27 at 14:48 +0300, Kalle Valo wrote:
>> Izzy Kulbe <kernel@unikorn.me> writes:
>> 
>> > nvm the last message, attached the wrong file using the 9270
>> > instead of the 9260 firmware, which obviously wouldn't work.
>> > Here's the working patch:
>> > 
>> > 
>> > Add support for Rivet Networks Killer Wireless-AC 1550 chipset, 
>> > which is using the Intel Wireless-AC 9260 chip
>> > 
>> > Signed-off-by: Izzy Kulbe <kernel@unikorn.me>
>> > 
>> > ---
>> 
>> You should put the comment "nvm the last message..." under the "---"
>> line so that git-am can ignore it.
>
> Sorry, still new to the whole process. should i just resend 
> that message with the proper order? 

Luca already replied, so don't resend yet. But please do read the
documentation, it should help you with the basics and have pointers to
other docs:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

-- 
Kalle Valo
