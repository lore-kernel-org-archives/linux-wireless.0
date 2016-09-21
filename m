Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:36510 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752240AbcIUHUI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Sep 2016 03:20:08 -0400
Received: by mail-it0-f52.google.com with SMTP id o3so119969507ita.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2016 00:20:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d0faec3a-b915-f4f6-5cd4-a4cff7f1dd7b@gmail.com>
References: <24d0d9c5-7695-9364-c5fa-97e9d52712dc@gmail.com>
 <CANUX_P1cFXTFk8c7iMZuVwoySMwVKPkLBOTr=sVC+t6xioPa=w@mail.gmail.com>
 <e22cedce-354f-cd41-f89c-8167f7063cfb@gmail.com> <79ad55e3-d7f7-0605-3499-a6b289dfb4f6@gmail.com>
 <CANUX_P1n3aVC=95q1=dJFU=7WYof=adm=P1anyhG0nnr9vKGKA@mail.gmail.com> <d0faec3a-b915-f4f6-5cd4-a4cff7f1dd7b@gmail.com>
From: Emmanuel Grumbach <egrumbach@gmail.com>
Date: Wed, 21 Sep 2016 10:20:06 +0300
Message-ID: <CANUX_P1p=8Zxq+GZd8p5NjAaEY7G7p8kdxacr7orpfE8hKKWig@mail.gmail.com> (sfid-20160921_092102_035708_0DEA63A1)
Subject: Re: Problem with 40Mhz on 2.5GHz with Intel 8260
To: Volker Mische <volker.mische@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>>
>>> I've set the iwlmvm power_scheme to 1 (and allowed the 40Mhz
>>> connection). First I thought it's good, but after a while the queue
>>> still got stuck. Especially after waking up from a suspend (not sure if
>>> that matters).
>>
>> Ok - good to know.
>>
>>>
>>> What are the next steps?
>>
>> can you try to unplug the power cord? I had reports that said that
>> this can help. Again, just a debug step to give us a hint of what you
>> can be experiencing.
>
> Unplug without any module parameters or combined with the
> cfg80211_disable_40mhz_24ghz or power_scheme one?

Nope - default configuration.

>
>
>> Besides this, we need to go for firmware debugging. But as I said,
>> don't expect this to be fast and easy. Please open a bug in
>> bugzilla.kernel.org. CC linuxwifi@intel.com and we will guide you
>> there on how to provide the information we need.
>
> OK, will do once I did try with unplugging. I've seen previous reports
> on the issue. As I'm already running a Kernel compiled from source I
> hope that at least I can move fast :)

Oh - the firmware debugging doesn't involve any source modification.

>
> Cheers,
>   Volker
>
