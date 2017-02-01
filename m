Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:36088 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbdBAO3S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Feb 2017 09:29:18 -0500
Received: by mail-it0-f42.google.com with SMTP id c7so17574790itd.1
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2017 06:29:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEvAWuH-HkC1VNbtLZdjtNQehcE2CR+k0RP=24xMx3TTxzFdUg@mail.gmail.com>
References: <CAEvAWuH-HkC1VNbtLZdjtNQehcE2CR+k0RP=24xMx3TTxzFdUg@mail.gmail.com>
From: =?UTF-8?Q?J=C3=B6rg_Pommnitz?= <j.pommnitz@gmail.com>
Date: Wed, 1 Feb 2017 15:29:17 +0100
Message-ID: <CAEvAWuHXVA=SHon6oBGXVaQgRxeNMHRY8Fs2kMdcKLQ++vZAVw@mail.gmail.com> (sfid-20170201_153010_635166_004344D0)
Subject: Re: Changing of WMM queue parameters forbidden for IBSS interfaces
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, wrong line in the link, the correct line is:
http://lxr.free-electrons.com/source/net/wireless/nl80211.c#L2289

regards
  Joerg

2017-02-01 15:24 GMT+01:00 J=C3=B6rg Pommnitz <j.pommnitz@gmail.com>:
> Hello all,
>
> I'm trying to change the WMM parameters for an IBSS network. I'm
> adding a command to set txq_params to iw. Sadly the current kernel
> code explicitly denies this for interfaces other than AP and P2P (see
> http://lxr.free-electrons.com/source/net/wireless/nl80211.c#L2279).
>
> Is there a reason why this should not be done for IBSS interfaces?
>
>
> Thanks in advance
>   Joerg
