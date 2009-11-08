Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:60962 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbZKHOy4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 09:54:56 -0500
Received: by ewy3 with SMTP id 3so2405346ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 06:55:00 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 7/7] rt2x00: Update copyright statements.
Date: Sun, 8 Nov 2009 15:54:58 +0100
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <1257689905-1611-1-git-send-email-gwingerde@gmail.com> <200911081525.58809.IvDoorn@gmail.com> <200911081548.09279.bzolnier@gmail.com>
In-Reply-To: <200911081548.09279.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911081554.58330.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 08 November 2009 15:25:58 Ivo van Doorn wrote:
> 
> > > diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> > > index 5c7d74a..3207b83 100644
> > > --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> > > +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> > > @@ -3,7 +3,13 @@
> > >  
> > >  	Based on the original rt2800pci.c and rt2800usb.c:
> > >  
> > > -	  Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> > > +	  Copyright (C) 2009 Ivo van Doorn <IvDoorn@gmail.com>
> > > +	  Copyright (C) 2009 Alban Browaeys <prahal@yahoo.com>
> > > +	  Copyright (C) 2009 Felix Fietkau <nbd@openwrt.org>
> > > +	  Copyright (C) 2009 Luis Correia <luis.f.correia@gmail.com>
> > > +	  Copyright (C) 2009 Mattias Nissler <mattias.nissler@gmx.de>
> > > +	  Copyright (C) 2009 Mark Asselstine <asselsm@gmail.com>
> > > +	  Copyright (C) 2009 Xose Vazquez Perez <xose.vazquez@gmail.com>
> > >  	  <http://rt2x00.serialmonkey.com>
> > >  
> > >  	This program is free software; you can redistribute it and/or modify
> > 
> > If Bartlomiej has no objections, we could just update the statements for rt2800lib.c/rt2800lib.h
> > to something similar as rt2800.h:
> > 
> > /*
> > 	Copyright (C) 2009 Bartlomiej Zolnierkiewicz
> > 	Copyright (C) 2009 Ivo van Doorn <IvDoorn@gmail.com>
> > 	Copyright (C) 2009 Alban Browaeys <prahal@yahoo.com>
> > 	Copyright (C) 2009 Felix Fietkau <nbd@openwrt.org>
> > 	Copyright (C) 2009 Luis Correia <luis.f.correia@gmail.com>
> > 	Copyright (C) 2009 Mattias Nissler <mattias.nissler@gmx.de>
> > 	Copyright (C) 2009 Mark Asselstine <asselsm@gmail.com>
> > 	Copyright (C) 2009 Xose Vazquez Perez <xose.vazquez@gmail.com>
> > 
> > 	This program is free software; you can redistribute it and/or modify
> > ....
> > 
> > because not sure if we need the seperate "based on" comment.. But I'll let Bartlomiej
> > decide on this one.
> 
> I think that the original version is correct and also documents new
> development direction well.

Ok, then the individual developers can move their copyright notice to above the
"based on" statements when new patches from them arrive.

Ivo
