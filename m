Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32837 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab2GSREG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 13:04:06 -0400
Received: by pbbrp8 with SMTP id rp8so4644298pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jul 2012 10:04:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1342171989.4983.2.camel@jlt3.sipsolutions.net>
References: <CAJuQfSjWuF=APbRTGbQoBi4fzusd_-CNfBrmS2WOoFWJd1A_hg@mail.gmail.com>
	<4FFFEAD3.6070203@broadcom.com>
	<1342171989.4983.2.camel@jlt3.sipsolutions.net>
Date: Thu, 19 Jul 2012 22:34:06 +0530
Message-ID: <CAJuQfSgm6tjDG8NfO4G4kE2MXyAF=0e7h1EX=BOydxv0rVoi2g@mail.gmail.com> (sfid-20120719_190410_572834_9FB1ABAE)
Subject: Re: BCM4313 injection support
From: sheerapthinath <sheerapthinath@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 13, 2012 at 3:03 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2012-07-13 at 11:30 +0200, Arend van Spriel wrote:
>> On 07/13/2012 09:37 AM, sheerapthinath wrote:
>> > Hi linux wireless,
>> >
>> > Is there hardware support for injection in BCM4313 wireless card(PCI
>> > id:14e4:4727)?
>> > I only that driver has partial support  without injection. I dunno if
>> > there is hardware support.
>> > Can you please let me know the details?
>>
>> From the documentation in [1] I see that mac80211 can handle this on a
>> monitor interface. brcmsmac does support monitoring, but I am not sure
>> what functionality is needed in the brcmsmac driver for injection. Maybe
>> Johannes can elaborate.
>
> You just get a normal TX, but without a sta pointer.
>
> johannes
>

As for as my hardware is concerned i could not figure out whether
there is support for injection. I know that the brcmsmac supports only
the monitoring mode. Since there is only partial support from
brcmsmac, i would like to patch to support injection.
Since iam a beginner, i don't know how to start the driver developement.
Can you please provide some documentation so that it would be helpful
in my development?

-- 
Regards,
Sheerapthinath OS
