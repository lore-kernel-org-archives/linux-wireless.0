Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:59195 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758380AbZIFTCi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Sep 2009 15:02:38 -0400
Received: by fg-out-1718.google.com with SMTP id 22so577151fge.1
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2009 12:02:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909062043.33801.mb@bu3sch.de>
References: <200909061449.45455.mb@bu3sch.de> <69e28c910909061142g546b4b0aqd123e8d800264505@mail.gmail.com>
	<200909062043.33801.mb@bu3sch.de>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 6 Sep 2009 21:02:20 +0200
Message-ID: <69e28c910909061202r286244aeq84ec9ce8a145d76e@mail.gmail.com>
Subject: Re: [PATCH] b43: PCMCIA is not experimental anymore
To: Michael Buesch <mb@bu3sch.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/9/6 Michael Buesch <mb@bu3sch.de>:
> On Sunday 06 September 2009 20:42:00 Gábor Stefanik wrote:
>> On Sun, Sep 6, 2009 at 2:49 PM, Michael Buesch<mb@bu3sch.de> wrote:
>> > PCMCIA support works well and is not experimental anymore.
>> >
>> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
>> >
>> > ---
>> >  drivers/net/wireless/b43/Kconfig |    4 ++--
>> >  1 file changed, 2 insertions(+), 2 deletions(-)
>> >
>> > --- wireless-testing.orig/drivers/net/wireless/b43/Kconfig
>> > +++ wireless-testing/drivers/net/wireless/b43/Kconfig
>> > @@ -42,8 +42,8 @@ config B43_PCICORE_AUTOSELECT
>> >        default y
>> >
>> >  config B43_PCMCIA
>> > -       bool "Broadcom 43xx PCMCIA device support (EXPERIMENTAL)"
>> > -       depends on B43 && SSB_PCMCIAHOST_POSSIBLE && EXPERIMENTAL
>> > +       bool "Broadcom 43xx PCMCIA device support"
>> > +       depends on B43 && SSB_PCMCIAHOST_POSSIBLE
>> >        select SSB_PCMCIAHOST
>> >        ---help---
>> >          Broadcom 43xx PCMCIA device support.
>> >
>> > --
>> > Greetings, Michael.
>> > _______________________________________________
>> > Bcm43xx-dev mailing list
>> > Bcm43xx-dev@lists.berlios.de
>> > https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
>> >
>>
>> This should be auto-selected depending on SSB_PCMCIAHOST_POSSIBLE (at
>> least if !EMBEDDED). There is no need for a separate config prompt if
>> it's not EXPERIMENTAL anymore.
>>
>
> Patch please
>
> --
> Greetings, Michael.
>

I need to fix my virtual machine first. (That's also why LP-PHY
development is stalled - I carelessly installed the VMware 7 beta
build I have been invited to, so that I can use all 4 CPU cores in the
VM - and the new VMware crashes on startup. Again, the VHD was not
lost, but I don't currently have the tools to read it.)

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
