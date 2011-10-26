Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46766 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab1JZXpA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 19:45:00 -0400
Received: by ywm3 with SMTP id 3so2066261ywm.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Oct 2011 16:45:00 -0700 (PDT)
Message-ID: <4EA89B8D.7060104@lwfinger.net> (sfid-20111027_014505_453251_34C43421)
Date: Wed, 26 Oct 2011 18:45:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Roman Proud <setamagiga@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8188RU no injection?
References: <CAF7qGM4BL10gn2786kW73sAk8f-y8CzX0rx2BQsY_Q96W=pfog@mail.gmail.com>
In-Reply-To: <CAF7qGM4BL10gn2786kW73sAk8f-y8CzX0rx2BQsY_Q96W=pfog@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/26/2011 05:29 PM, Roman Proud wrote:
> Hi there,
>
> i hope you guys can help me.
> I wanted a new Wifi card, because mine has no injection, what i need sometimes.
>
> So i forced the Internet to find that a 8187 would be best for. So i
> bought the 8188 (newer = better?)... i never had thought about so much
> difference in just one number... it was horrible to even get the card
> work, first no monitor mode works, but now it does (i dunno why
> O_o)... The only thing i miss is Package injection.
>
> So my Question. Is it there? is it in the driver and i just have to do
> some magic again like i did with the monitor mode?
> If not, is there any Patch? (i didn't find anything...)
> Or should i simply send the damn thing back and get me an 8187? (its
> not that simple, and i like hacking into my linux, so one of the first
> both, would be nicer)

I found that packetspammer works just fine with rtl8192cu.

Larry

