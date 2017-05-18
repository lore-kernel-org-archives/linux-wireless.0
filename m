Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f176.google.com ([209.85.213.176]:35329 "EHLO
        mail-yb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755070AbdERWu1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 18:50:27 -0400
Received: by mail-yb0-f176.google.com with SMTP id p143so14115702yba.2
        for <linux-wireless@vger.kernel.org>; Thu, 18 May 2017 15:50:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8780fd64-329f-2a42-4bcd-10abf60976fc@lwfinger.net>
References: <9b9d08fb-cbcd-5c12-feb8-5434a20cbd94@kpanic.de> <8780fd64-329f-2a42-4bcd-10abf60976fc@lwfinger.net>
From: Ian W MORRISON <ianwmorrison@gmail.com>
Date: Fri, 19 May 2017 08:50:26 +1000
Message-ID: <CAFXWsS85L6tahPX_34smvAU6rRhhkd_EQC3EMU2ev2t3aSpNww@mail.gmail.com> (sfid-20170519_005032_072434_29D09408)
Subject: Re: crash in r8723bs
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stefan Assmann <sassmann@kpanic.de>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 May 2017 at 05:03, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 05/17/2017 10:05 AM, Stefan Assmann wrote:
>>
>> Hi Larry,
>>
>> the rtl8723bs made it into staging, awesome.
>> I built a kernel to test it but it goes down the drain pretty quickly
>> on modprobe. Going forward who should I discuss bugs with?
>>
>> Here's what's going on atm.
>>
>>    Stefan
>>

>> [  125.485622] CPU: 1 PID: 456 Comm: modprobe Tainted: G         C
>> 4.12.0-rc1+ #1

If the kernel is built from v4.12-rc1 then you need to add
https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/commit/?h=staging-linus&id=ca6e8cdbe1865caf7b05483e1a242e72d9bc919f

Regards,
Ian
