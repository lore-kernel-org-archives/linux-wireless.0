Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:33379 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935544AbcKOOxg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 09:53:36 -0500
Received: by mail-qk0-f174.google.com with SMTP id x190so137632030qkb.0
        for <linux-wireless@vger.kernel.org>; Tue, 15 Nov 2016 06:53:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87polwq2nq.fsf@kamboji.qca.qualcomm.com>
References: <773DB8A82AB6A046AE0195C68612A31901C5B293@sbs2003.acksys.local>
 <566849DB.9040901@candelatech.com> <079401d132a6$7e7e2050$7b7a60f0$@acksys.fr>
 <CABUTiXWg3t5qK6O5ooDE+4=Xk3Msybs5mu9+tQm_Bb0wdSrfWQ@mail.gmail.com>
 <87twbnueqv.fsf@kamboji.qca.qualcomm.com> <CABUTiXW5QSh2KkD+sQ-6QOD5zTce0dun+nyfAMnvL580U=OVNw@mail.gmail.com>
 <871syn5fnb.fsf@qca.qualcomm.com> <CABUTiXV8eFsW4MJET4spvjVQvFgi66NV7hLLxFC6Ttqs1znxjA@mail.gmail.com>
 <87polwq2nq.fsf@kamboji.qca.qualcomm.com>
From: Bruno Antunes <baantunes@gmail.com>
Date: Tue, 15 Nov 2016 14:53:14 +0000
Message-ID: <CABUTiXXKm0k56M4LcxegwNgr+91SF+mX4tniHxJ5ViPy91HGhA@mail.gmail.com> (sfid-20161115_155339_861841_99425D69)
Subject: Re: [OpenWrt-Devel] ATH10K VLAN firmware issue
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        voncken <cedric.voncken@acksys.fr>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Ben Greear <greearb@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 November 2016 at 13:43, Valo, Kalle <kvalo@qca.qualcomm.com> wrote:
> Bruno Antunes <baantunes@gmail.com> writes:
>
>> On 7 November 2016 at 18:06, Valo, Kalle <kvalo@qca.qualcomm.com> wrote:
>>> Bruno Antunes <baantunes@gmail.com> writes:
>>>
>>>> On 4 November 2016 at 21:17, Valo, Kalle <kvalo@qca.qualcomm.com> wrote:
>>>>
>>>>> Can someone file a bug to bugzilla about this so that all the info is
>>>>> properly stored? The more comprehensive the report is the better.
>>>>>
>>>>> https://bugzilla.kernel.org/
>>>>
>>>> I will file a bug report.
>>>
>>> Thanks, it's good to store all in one place so that it's easier to find
>>> the relevant info.
>>
>> Just file the bug with the ID 187241 - VLAN support in ATH10k Feel
>> free to ask for adicional info. I did not mention any names in the bug
>> report fell free to take credit if wanted.
>
> Thanks. I'll report it to the firmware team, let's see what happens. If
> there's more information which might help to fix this feel free to
> update that to the bug report.

I'm finishing my tests and will update the bug report ASAP.

Turns out the bad throughput was the result of a failure in the switch port.

With Ben's firmware the VLAN support is working fine with security.

Thanks,
Bruno
>
> https://bugzilla.kernel.org/show_bug.cgi?id=187241
>
> --
> Kalle Valo
