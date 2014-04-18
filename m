Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:55462 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaDROe5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2014 10:34:57 -0400
Received: by mail-ig0-f169.google.com with SMTP id h18so1026582igc.0
        for <linux-wireless@vger.kernel.org>; Fri, 18 Apr 2014 07:34:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53512D04.5070808@gmail.com>
References: <CABtfrpCY7cOkw-dPwv5=8YxNAd4idpvyQV9zL3gU9RQiaSxpCw@mail.gmail.com>
	<CANUX_P0fLsNx+c7VnVggbZSGvnarF3inP7M115p-up3DfXyuuA@mail.gmail.com>
	<CABtfrpDYL55KJ=Ehr0E8wNtLMbcMmJohz3oA9BgtriMv7hw_qw@mail.gmail.com>
	<CABtfrpAY7OvH38E_+4QLGwWr2iQB1Rq45zzxdZwdM2Q7rc1NpA@mail.gmail.com>
	<5350B340.9020201@gmail.com>
	<53512D04.5070808@gmail.com>
Date: Fri, 18 Apr 2014 18:34:57 +0400
Message-ID: <CABtfrpB440bsy7xDu1pdTu2zM+ZJHLDQKb4MLaMRf4hnVXBsNQ@mail.gmail.com> (sfid-20140418_163502_024019_8C7E75B2)
Subject: Re: iwlwifi null pointer dereference
From: Alexander Monakov <amonakov@gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 18, 2014 at 5:47 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>
>
> On 04/18/2014 08:08 AM, Emmanuel Grumbach wrote:
>> Hi,
>>
>> On 04/17/2014 11:56 PM, Alexander Monakov wrote:
>>> Emmanuel,
>>>
>>> I'm curious about the plans w.r.t this fix; is it going to
>>> iwlwifi-next.git?  Thanks again.
>>>
>>
>> It will go to iwlwifi-fixes.
>>
>
> I have to say that this is really strange - I must miss something. It looks like the ISR is called even before it is requested...
> So I definitely want to understand what is happening here before applying the fix.

Sure, I can help with further investigation.  Would it help if I bisected?

Alexander
