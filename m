Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:33463 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751616AbdBOKzb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 05:55:31 -0500
Received: by mail-ua0-f176.google.com with SMTP id i68so103386324uad.0
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2017 02:55:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <586c8cf6-75fb-64cb-adaa-4c5de7ec7008@broadcom.com>
References: <CANU0Mn00ju_SZ3L+ipdnZ5R-Y1m+T=MhjHmBjMpKN_i8NPWsrg@mail.gmail.com>
 <dea21c18-30a4-f236-6f8b-1bf8d4391e0b@broadcom.com> <CANU0Mn2Fp=3tYb70qD7J_duA0f1wbRNr_Q3e5iv3pBTHtWM4zg@mail.gmail.com>
 <586c8cf6-75fb-64cb-adaa-4c5de7ec7008@broadcom.com>
From: ravin goyal <ravirocks1021@gmail.com>
Date: Wed, 15 Feb 2017 16:25:09 +0530
Message-ID: <CANU0Mn01mQoWfxvWK_jLRyM9MZwDR7Baeah6ZkJ6pNhxB=YeKQ@mail.gmail.com> (sfid-20170215_115533_455467_E4CAD54F)
Subject: Re: wireless driver crashing frequently
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

okay thanks for the help.

regards
ravin

On 15 February 2017 at 16:20, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
>
> On 15-2-2017 11:38, ravin goyal wrote:
>> that is what I have found on my banana pi board running raspbian lite
>> 3.4.112-sun8i.
>> removing bcmdhd results in removing my wlan0 interface from the
>> list(iwconfig/ifconfig/ip).
>
> Ok. If it is raspbian that choose to include bcmdhd in their distro I
> would suggest to file the bug there [1].
>
> Regards,
> Arend
>
> [1] https://www.raspbian.org/RaspbianBugs
