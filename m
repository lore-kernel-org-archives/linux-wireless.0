Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:59379 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814AbZEUCNF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 22:13:05 -0400
Received: by wf-out-1314.google.com with SMTP id 26so263980wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 20 May 2009 19:13:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69e28c910905200137o4e501ed2r65b5b79a1b5a087e@mail.gmail.com>
References: <a8e1da0905192221y449e9820x63d46a6dcbfc1dfc@mail.gmail.com>
	 <69e28c910905200137o4e501ed2r65b5b79a1b5a087e@mail.gmail.com>
Date: Thu, 21 May 2009 10:13:05 +0800
Message-ID: <a8e1da0905201913i7318ee4aoe4e579632cc566b6@mail.gmail.com>
Subject: Re: b43 lp-phy status
From: Dave Young <hidave.darkstar@gmail.com>
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/5/20 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Wed, May 20, 2009 at 7:21 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
>> Hi, michael
>>
>> What's the status of b43 for lp-phy? Is is possible to use it with
>> basic functionality now?
>>
>> I have such wireless dev in my dell 5400 laptop.
>>
>> Now I just use the broadcom hybrid driver which can not pass building
>> in latest kernel by default. I make some change to it's wl_linux.c to
>> make it compiled. Although the wl.ko works, it has some nasty bug
>> which will be triggered after modprobe the module several times.
>>
>> Could you tell what I can do for the b43 lpy? ie. some testing?
>
> Unfortunately no substantial code additions related to LP have been
> checked in so far - the reverse engineering is complete, but Michael
> is the only person working on converting the specs to code, and he's
> too busy to work on LP.
>
> (Should someone send me a Dell 1395, I could probably start working on
> it, but I'm busy with zd1211rw & iwlagn right now.)

Thanks for your response. Then are there some guideline to do such coding?

>
>>
>> --
>> Regards
>> dave
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
>



-- 
Regards
dave
