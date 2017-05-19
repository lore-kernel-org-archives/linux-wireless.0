Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:59413 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750978AbdESF54 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 01:57:56 -0400
Subject: Re: crash in r8723bs
To: Ian W MORRISON <ianwmorrison@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <9b9d08fb-cbcd-5c12-feb8-5434a20cbd94@kpanic.de>
 <8780fd64-329f-2a42-4bcd-10abf60976fc@lwfinger.net>
 <CAFXWsS85L6tahPX_34smvAU6rRhhkd_EQC3EMU2ev2t3aSpNww@mail.gmail.com>
From: Stefan Assmann <sassmann@kpanic.de>
Message-ID: <7ea99377-6424-a307-bf95-d370ae6fbbe3@kpanic.de> (sfid-20170519_075816_227788_8165B6AE)
Date: Fri, 19 May 2017 07:57:50 +0200
MIME-Version: 1.0
In-Reply-To: <CAFXWsS85L6tahPX_34smvAU6rRhhkd_EQC3EMU2ev2t3aSpNww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19.05.2017 00:50, Ian W MORRISON wrote:
> On 19 May 2017 at 05:03, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> On 05/17/2017 10:05 AM, Stefan Assmann wrote:
>>>
>>> Hi Larry,
>>>
>>> the rtl8723bs made it into staging, awesome.
>>> I built a kernel to test it but it goes down the drain pretty quickly
>>> on modprobe. Going forward who should I discuss bugs with?
>>>
>>> Here's what's going on atm.
>>>
>>>    Stefan
>>>
> 
>>> [  125.485622] CPU: 1 PID: 456 Comm: modprobe Tainted: G         C
>>> 4.12.0-rc1+ #1
> 
> If the kernel is built from v4.12-rc1 then you need to add
> https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/commit/?h=staging-linus&id=ca6e8cdbe1865caf7b05483e1a242e72d9bc919f

Thanks Ian, that works.

  Stefan
