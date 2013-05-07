Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f53.google.com ([209.85.128.53]:37627 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab3EGGQV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 02:16:21 -0400
Received: by mail-qe0-f53.google.com with SMTP id cz11so107187qeb.26
        for <linux-wireless@vger.kernel.org>; Mon, 06 May 2013 23:16:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5187C502.10407@gmail.com>
References: <5187C502.10407@gmail.com>
Date: Tue, 7 May 2013 09:16:20 +0300
Message-ID: <CAApCBGwp8NDsAYDzFc8_Pgx09anYoW894cygqNF55vV_-6dq6Q@mail.gmail.com> (sfid-20130507_081626_584504_C1332FB1)
Subject: Re: RT5390 rev 0503 problems
From: wireless newbie <wnewbie72@gmail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes, that is exactly the same patch that I used. It does it's job
fixing my signal levels with one antenna. I was just wondering if
there could be something
else that is different with this revision, because the performance
seems to be worse than with rt3070 on same environment.

2013/5/6 Xose Vazquez Perez <xose.vazquez@gmail.com>:
> wireless newbie wrote:
>
>> Has anyone experience with Ralink RT5390 chip with revision 0503? I
>> have that chip on my wireless usb module (WPER-172gn). I'm able to use
>> only one antenna with it but it has very poor rx signal level that
>> way. Adding second antenna for testing purposes clearly improves rx
>> level but that is no option for me.
>>
>> I noticed in the list that someone had same sort of problem with
>> rt5390 rev 1502. Problem was hardware antenna diversity that wasn't
>> handled properly on the driver. Driver patch was provided to fix that.
>> I applied those same changes for rev 0503 and that solved my rx level
>> problem too.
>
> is it like this ?
> http://marc.info/?l=linux-wireless&m=134136097328697
