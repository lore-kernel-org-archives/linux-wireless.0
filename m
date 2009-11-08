Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:58856 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbZKHO6S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 09:58:18 -0500
Received: by ewy3 with SMTP id 3so2406902ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 06:58:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911081554.58330.IvDoorn@gmail.com>
References: <1257689905-1611-1-git-send-email-gwingerde@gmail.com>
	 <200911081525.58809.IvDoorn@gmail.com>
	 <200911081548.09279.bzolnier@gmail.com>
	 <200911081554.58330.IvDoorn@gmail.com>
Date: Sun, 8 Nov 2009 14:58:22 +0000
Message-ID: <880c1630911080658w81f7a05nc1f4d999d3292a70@mail.gmail.com>
Subject: Re: [rt2x00-users] [PATCH 7/7] rt2x00: Update copyright statements.
From: Luis Correia <buga@loide.net>
To: rt2x00 Users List <users@rt2x00.serialmonkey.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 8, 2009 at 14:54, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> On Sunday 08 November 2009, Bartlomiej Zolnierkiewicz wrote:
>> On Sunday 08 November 2009 15:25:58 Ivo van Doorn wrote:
>>
>> > > diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>> > > index 5c7d74a..3207b83 100644
>> > > --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> > > +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> > > @@ -3,7 +3,13 @@
>> > >
>> > >   Based on the original rt2800pci.c and rt2800usb.c:
>> > >
>> > > -   Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
>> > > +   Copyright (C) 2009 Ivo van Doorn <IvDoorn@gmail.com>
>> > > +   Copyright (C) 2009 Alban Browaeys <prahal@yahoo.com>
>> > > +   Copyright (C) 2009 Felix Fietkau <nbd@openwrt.org>
>> > > +   Copyright (C) 2009 Luis Correia <luis.f.correia@gmail.com>
>> > > +   Copyright (C) 2009 Mattias Nissler <mattias.nissler@gmx.de>
>> > > +   Copyright (C) 2009 Mark Asselstine <asselsm@gmail.com>
>> > > +   Copyright (C) 2009 Xose Vazquez Perez <xose.vazquez@gmail.com>
>> > >     <http://rt2x00.serialmonkey.com>
>> > >
>> > >   This program is free software; you can redistribute it and/or modify
>> >
>> > If Bartlomiej has no objections, we could just update the statements for rt2800lib.c/rt2800lib.h
>> > to something similar as rt2800.h:
>> >
>> > /*
>> >     Copyright (C) 2009 Bartlomiej Zolnierkiewicz
>> >     Copyright (C) 2009 Ivo van Doorn <IvDoorn@gmail.com>
>> >     Copyright (C) 2009 Alban Browaeys <prahal@yahoo.com>
>> >     Copyright (C) 2009 Felix Fietkau <nbd@openwrt.org>
>> >     Copyright (C) 2009 Luis Correia <luis.f.correia@gmail.com>
>> >     Copyright (C) 2009 Mattias Nissler <mattias.nissler@gmx.de>
>> >     Copyright (C) 2009 Mark Asselstine <asselsm@gmail.com>
>> >     Copyright (C) 2009 Xose Vazquez Perez <xose.vazquez@gmail.com>
>> >
>> >     This program is free software; you can redistribute it and/or modify
>> > ....
>> >
>> > because not sure if we need the seperate "based on" comment.. But I'll let Bartlomiej
>> > decide on this one.
>>
>> I think that the original version is correct and also documents new
>> development direction well.
>
> Ok, then the individual developers can move their copyright notice to above the
> "based on" statements when new patches from them arrive.
>
> Ivo
>
> _______________________________________________
> users mailing list
> users@rt2x00.serialmonkey.com
> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com
>

For all files where I'm referred:

Acked-by: Luis Correia <luis.f.correia@gmail.com>
