Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:33809 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753706AbcIVFc5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 01:32:57 -0400
Received: by mail-io0-f178.google.com with SMTP id q92so75427531ioi.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2016 22:32:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <968d1def-738f-36da-83bd-b10cc98c8093@gmail.com>
References: <24d0d9c5-7695-9364-c5fa-97e9d52712dc@gmail.com>
 <CANUX_P1cFXTFk8c7iMZuVwoySMwVKPkLBOTr=sVC+t6xioPa=w@mail.gmail.com>
 <e22cedce-354f-cd41-f89c-8167f7063cfb@gmail.com> <79ad55e3-d7f7-0605-3499-a6b289dfb4f6@gmail.com>
 <CANUX_P1n3aVC=95q1=dJFU=7WYof=adm=P1anyhG0nnr9vKGKA@mail.gmail.com>
 <d0faec3a-b915-f4f6-5cd4-a4cff7f1dd7b@gmail.com> <CANUX_P1p=8Zxq+GZd8p5NjAaEY7G7p8kdxacr7orpfE8hKKWig@mail.gmail.com>
 <968d1def-738f-36da-83bd-b10cc98c8093@gmail.com>
From: Emmanuel Grumbach <egrumbach@gmail.com>
Date: Thu, 22 Sep 2016 08:32:55 +0300
Message-ID: <CANUX_P0Ai+tzmq90rmHkVP69PZ5c=-kayLOQnmHebLGNeJ3nMw@mail.gmail.com> (sfid-20160922_073301_434293_E8E0E38A)
Subject: Re: Problem with 40Mhz on 2.5GHz with Intel 8260
To: Volker Mische <volker.mische@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 21, 2016 at 11:19 PM, Volker Mische <volker.mische@gmail.com> wrote:
> Hi,
>
> On 09/21/2016 09:20 AM, Emmanuel Grumbach wrote:
>>>> can you try to unplug the power cord? I had reports that said that
>>>> this can help. Again, just a debug step to give us a hint of what you
>>>> can be experiencing.
>>>
>>> Unplug without any module parameters or combined with the
>>> cfg80211_disable_40mhz_24ghz or power_scheme one?
>>
>> Nope - default configuration.
>
> the issue also happens when the power cord is unplugged.

Ok - thanks for trying.

>
>>>> Besides this, we need to go for firmware debugging. But as I said,
>>>> don't expect this to be fast and easy. Please open a bug in
>>>> bugzilla.kernel.org. CC linuxwifi@intel.com and we will guide you
>>>> there on how to provide the information we need.
>
> I've filled bug 172431
>
> [1]: https://bugzilla.kernel.org/show_bug.cgi?id=172431

Saw that. Thanks.

>
> Cheers,
>   Volker
