Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:35013 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752465AbdHKFBx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Aug 2017 01:01:53 -0400
Received: by mail-vk0-f46.google.com with SMTP id d124so9874845vkf.2
        for <linux-wireless@vger.kernel.org>; Thu, 10 Aug 2017 22:01:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <911aa880-37bc-5825-f2ed-09f35ca01fb8@lwfinger.net>
References: <CA+ToGPGMmtJNeHo7OVjpgCQo7p8_d9Bx6=oRx+6Z_MgFejaHxA@mail.gmail.com>
 <5B2DA6FDDF928F4E855344EE0A5C39D1057D5F73@RTITMBSV07.realtek.com.tw>
 <CA+ToGPG=FMUPQiCNtD_zKfXjS+83qmAiOSUo+Yt7EG6waSMG7Q@mail.gmail.com> <911aa880-37bc-5825-f2ed-09f35ca01fb8@lwfinger.net>
From: Diego Viola <diego.viola@gmail.com>
Date: Fri, 11 Aug 2017 02:01:51 -0300
Message-ID: <CA+ToGPGS=sPsauefY4gAQoHCN1nLC_54HA_bD5wW9z0iQgd7=Q@mail.gmail.com> (sfid-20170811_070156_874531_4BB67613)
Subject: Re: Poor wi-fi signal level with 4.12 kernel (rtl8723be)
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

On Thu, Aug 10, 2017 at 2:23 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 08/09/2017 09:45 PM, Diego Viola wrote:
>>
>> On Wed, Aug 9, 2017 at 11:42 PM, Pkshih <pkshih@realtek.com> wrote:
>>>
>>>
>>>
>>>> -----Original Message-----
>>>> From: Diego Viola [mailto:diego.viola@gmail.com]
>>>> Sent: Thursday, August 10, 2017 4:30 AM
>>>> To: Pkshih
>>>> Subject: Poor wi-fi signal level with 4.12 kernel (rtl8723be)
>>>>
>>>> Hello,
>>>>
>>>> Any ideas when this will be fixed?
>>>>
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux
>>>> .git/commit/?id=f95d95a7cd5514549dcf6ba754f0ee834cce3e1f
>>>>
>>>> There are a few users affected by this problem:
>>>>
>>>> https://bbs.archlinux.org/viewtopic.php?id=228190
>>>>
>>>
>>> Hi Diego,
>>>
>>> Yes, I had proposed solution to rtlwifi maintainer Larry, and he will
>>> submit
>>> the patches after verifying.
>>>
>>> Thanks
>>> PK
>>>
>>
>> Great, please give me an update when the fix is upstreamed, so I can
>> tell those users to try it.
>>
>> Thank you, I greatly appreciate your effort.
>
>
> Diego,
>
> I'm not sure what was wrong with my previous testing, but the kernels at
> git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git
> correctly handle the antenna selection. Use them and all should be OK. If
> not, write me again; however, Cc linux-wireless@vger.kernel.org. I promise
> that I will ignore any messages sent to me privately, unless there is
> sensitive info in the message.
>
> Larry
>

This is a follow-up of my previous email.

I asked a user to try the latest wireless-drivers-next.git[1] and he
reported the problem still persists.

https://www.reddit.com/r/archlinux/comments/6qjmbo/psa_updating_the_kernel_to_41231arch_might_break/dlgejv5/

[1] git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git

Thanks,
Diego
