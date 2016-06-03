Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:34555 "EHLO
	mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbcFCHbX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 03:31:23 -0400
Received: by mail-vk0-f66.google.com with SMTP id a6so12093543vkg.1
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jun 2016 00:31:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1464881803.2169.11.camel@sipsolutions.net>
References: <1464880903-13116-1-git-send-email-dibyajyotig@gmail.com> <1464881803.2169.11.camel@sipsolutions.net>
From: Dibyajyoti Ghosh <dibyajyotig@gmail.com>
Date: Fri, 3 Jun 2016 13:01:21 +0530
Message-ID: <CACtQq=YDbYsO4k5oERvqwR38i1BYQkC0_4So6W3D4Atk-_NTpQ@mail.gmail.com> (sfid-20160603_093126_817821_84C2AA0D)
Subject: Re: [PATCH] Support for 32 bit iwpriv on 64 bits kernels
To: Johannes Berg <johannes@sipsolutions.net>
Cc: WiFi Mailing List <linux-wireless@vger.kernel.org>,
	Ujjal Roy <royujjal@gmail.com>,
	Prasun Maiti <prasunmaiti87@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

Sorry for the conflict. We misunderstood from our kernel-patch related
conversation that it is you are reluctant to accept that. So we
attempted to accomplish the same through app-side modification. Any
way, sorry again.

However, we are again concentrating on our kernel side modification,
and will update you soon.

Thanks,
Dibyajyoti


On Thu, Jun 2, 2016 at 9:06 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2016-06-02 at 20:51 +0530, Dibyajyoti Ghosh wrote:
>> This patch adds pointer conversion from 32 bit to 64 bit and vice
>> versa,
>> if the ioctl is issued from 32 bit iwpriv to 64 bit Kernel.
>>
> Huh? the kernel should handle that, no? And didn't you just submit a
> patch for it, so you break it again with this change?
>
> johannes
