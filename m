Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34821 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934199AbcI0PEw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Sep 2016 11:04:52 -0400
Subject: Re: wil6200
To: Vikram <vikrampal@gmail.com>
References: <CALZLQ=biEM2efkYhkr6PYu7wn_CJTJ9LQg+0VJvf2rMgmKPS9w@mail.gmail.com>
 <a3435bed-4892-4606-44ac-523e47f57b1b@codeaurora.org>
 <CALZLQ=anWS6ThxEOnifRcxgYyk3BvWwMUFqTtZdOMcqZYA+igA@mail.gmail.com>
Cc: linux-wireless@vger.kernel.org
From: Lior David <liord@codeaurora.org>
Message-ID: <f95a0e74-6771-05ad-6019-73a0bb20916a@codeaurora.org> (sfid-20160927_170456_779302_E99D4137)
Date: Tue, 27 Sep 2016 18:04:44 +0300
MIME-Version: 1.0
In-Reply-To: <CALZLQ=anWS6ThxEOnifRcxgYyk3BvWwMUFqTtZdOMcqZYA+igA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/26/2016 9:05 PM, Vikram wrote:
> Hi Lior,
> 
> On 26 September 2016 at 18:19, Lior David <liord@codeaurora.org> wrote:
>> On 9/25/2016 6:15 PM, Vikram wrote:
>>> Hi,
>>>
>>> Could you please let me know as to how to change the mode of wil6200
>>> chip from WBE to WiFi?
>>>
>>> Regards,
>>> Vikram
>>>
>> What is the exact device you are using? Older devices have firmware that only
>> supports WBE mode.
>>
>> Thanks,
>> Lior
> 
> I'm using Dell Wireless DW1601 7Gbps WiGig 802.11ad 802.11n 2*2 WiFi
> Half Mini Card abgn+ad 2*2:2
Unfortunately it looks like this is an old chip which does not support WIFI
mode. There are 2 main problems:
1. The chip has its firmware burned into flash and cannot be upgraded, unlike
newer chips where firmware can be loaded into memory (so wil6210 driver can use
the firmware file from /lib/firmware).
2. Based on the product description this card was specifically used to connect
to the Dell wireless dock which used WBE, so it has a firmware with only WBE
support.

Thanks,
Lior

> 
> Regards,
> Vikram
> 
