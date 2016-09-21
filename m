Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33739 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932340AbcIUUT0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Sep 2016 16:19:26 -0400
Received: by mail-wm0-f65.google.com with SMTP id w84so10538542wmg.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2016 13:19:25 -0700 (PDT)
Subject: Re: Problem with 40Mhz on 2.5GHz with Intel 8260
To: Emmanuel Grumbach <egrumbach@gmail.com>
References: <24d0d9c5-7695-9364-c5fa-97e9d52712dc@gmail.com>
 <CANUX_P1cFXTFk8c7iMZuVwoySMwVKPkLBOTr=sVC+t6xioPa=w@mail.gmail.com>
 <e22cedce-354f-cd41-f89c-8167f7063cfb@gmail.com>
 <79ad55e3-d7f7-0605-3499-a6b289dfb4f6@gmail.com>
 <CANUX_P1n3aVC=95q1=dJFU=7WYof=adm=P1anyhG0nnr9vKGKA@mail.gmail.com>
 <d0faec3a-b915-f4f6-5cd4-a4cff7f1dd7b@gmail.com>
 <CANUX_P1p=8Zxq+GZd8p5NjAaEY7G7p8kdxacr7orpfE8hKKWig@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Volker Mische <volker.mische@gmail.com>
Message-ID: <968d1def-738f-36da-83bd-b10cc98c8093@gmail.com> (sfid-20160921_221943_302850_D02CAFF3)
Date: Wed, 21 Sep 2016 22:19:22 +0200
MIME-Version: 1.0
In-Reply-To: <CANUX_P1p=8Zxq+GZd8p5NjAaEY7G7p8kdxacr7orpfE8hKKWig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 09/21/2016 09:20 AM, Emmanuel Grumbach wrote:
>>> can you try to unplug the power cord? I had reports that said that
>>> this can help. Again, just a debug step to give us a hint of what you
>>> can be experiencing.
>>
>> Unplug without any module parameters or combined with the
>> cfg80211_disable_40mhz_24ghz or power_scheme one?
> 
> Nope - default configuration.

the issue also happens when the power cord is unplugged.

>>> Besides this, we need to go for firmware debugging. But as I said,
>>> don't expect this to be fast and easy. Please open a bug in
>>> bugzilla.kernel.org. CC linuxwifi@intel.com and we will guide you
>>> there on how to provide the information we need.

I've filled bug 172431

[1]: https://bugzilla.kernel.org/show_bug.cgi?id=172431

Cheers,
  Volker
