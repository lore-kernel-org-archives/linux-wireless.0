Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:43618 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933558AbeE1TjC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 May 2018 15:39:02 -0400
Subject: Re: [PATCH 1/2] NFC: st95hf: initialize semaphore and mutex earlier
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org
References: <20180516133247.25986-1-daniel@zonque.org>
 <6eed2f2f-b3cc-0582-220c-e4ccd2175fd7@zonque.org>
 <20180528145000.GA11829@zurbaran.ger.intel.com>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <a8713f8c-a3be-6248-9fd6-b7e91048c9b7@zonque.org> (sfid-20180528_213945_548995_059F007E)
Date: Mon, 28 May 2018 21:39:01 +0200
MIME-Version: 1.0
In-Reply-To: <20180528145000.GA11829@zurbaran.ger.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, May 28, 2018 04:50 PM, Samuel Ortiz wrote:
> Hi Daniel,
> 
> On Mon, May 28, 2018 at 04:35:15PM +0200, Daniel Mack wrote:
>> On Wednesday, May 16, 2018 03:32 PM, Daniel Mack wrote:
>>> 'rm_lock' and 'exchange_lock' need to be ready before the IRQ handler has a
>>> chance to fire.
>>>
>>> This fixes the oops below.
>>
>> Nobody seems to be interested in these. Davem, can you take them through
>> your tree or is there anyone else I can ping?
> I'm going to gather all pending NFC patches this week, including this
> one.
> They will land in either the nfc-next or nfc-fixes tree.

Ah, perfect. Sorry for nagging. I just wanted to be sure they're not 
forgotten :)


Thanks,
Daniel
