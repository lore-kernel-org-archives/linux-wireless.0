Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:55234 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbaDQU4N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 16:56:13 -0400
Received: by mail-ie0-f179.google.com with SMTP id lx4so906331iec.38
        for <linux-wireless@vger.kernel.org>; Thu, 17 Apr 2014 13:56:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABtfrpDYL55KJ=Ehr0E8wNtLMbcMmJohz3oA9BgtriMv7hw_qw@mail.gmail.com>
References: <CABtfrpCY7cOkw-dPwv5=8YxNAd4idpvyQV9zL3gU9RQiaSxpCw@mail.gmail.com>
	<CANUX_P0fLsNx+c7VnVggbZSGvnarF3inP7M115p-up3DfXyuuA@mail.gmail.com>
	<CABtfrpDYL55KJ=Ehr0E8wNtLMbcMmJohz3oA9BgtriMv7hw_qw@mail.gmail.com>
Date: Fri, 18 Apr 2014 00:56:12 +0400
Message-ID: <CABtfrpAY7OvH38E_+4QLGwWr2iQB1Rq45zzxdZwdM2Q7rc1NpA@mail.gmail.com> (sfid-20140417_225628_818535_1707FA92)
Subject: Re: iwlwifi null pointer dereference
From: Alexander Monakov <amonakov@gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel,

I'm curious about the plans w.r.t this fix; is it going to
iwlwifi-next.git?  Thanks again.

On Sun, Apr 13, 2014 at 12:49 PM, Alexander Monakov <amonakov@gmail.com> wrote:
> On Sun, Apr 13, 2014 at 11:23 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>> On Sat, Apr 12, 2014 at 6:11 PM, Alexander Monakov <amonakov@gmail.com> wrote:
>>> Hello,
>>>
>>> On a laptop with Wireless-N 135 card and 3.14.0 kernel I'm getting a
>>> kernel oops on cold boot ans wireless seems unusable, but suprisingly
>>> everything works fine after a reboot:
>>
>> Wow - interesting - you are getting an interrupt before we even enable them.
>>
>> Does this help you?
>
> Yes, it did help. Thanks.
>
> (regarding interrupts, after installing an mSATA SSD that goes into
> the mini-PCIe slot next to the wireless card, I've noticed that
> "events" (mostly interrupts I guess) shown by PowerTop for the
> wireless card and the SATA controller seem correlated, even though the
> disk should be idle; I wonder what that means)
>
> Alexander
