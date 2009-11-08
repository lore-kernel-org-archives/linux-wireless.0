Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:39497 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbZKHP1n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 10:27:43 -0500
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH v2] rt2x00: Update copyright statements.
Date: Sun, 8 Nov 2009 16:26:28 +0100
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1257692976-2036-1-git-send-email-gwingerde@gmail.com> <200911081622.07678.IvDoorn@gmail.com>
In-Reply-To: <200911081622.07678.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200911081626.28320.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009 16:22:07 Ivo van Doorn wrote:
> On Sunday 08 November 2009, Gertjan van Wingerde wrote:
> > As mentioned on the linux-wireless mailing list, the current copyright statements in the rt2x00 are
> > meaningless, as the rt2x00 project is not even a formal legal entity. Therefore it is better to replace
> > the existing copyright statements with copyright statements for the people that actually wrote the code.
> > 
> > Note: Updated to the best of my knowledge with respect to who contributed considerable amounts of code.
> > 
> > Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> > CC: Ivo van Doorn <IvDoorn@gmail.com>
> > CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

NAK, stop trying to reverse the history.

Just replace rt2x00 claims with personal ones without moving
"based on" around.

> > diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> > index 5c7d74a..aed72a9 100644
> > --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> > +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> > @@ -1,10 +1,15 @@
> >  /*
> > -	Copyright (C) 2009 Bartlomiej Zolnierkiewicz
> > -
> > -	Based on the original rt2800pci.c and rt2800usb.c:
> > -
> > -	  Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> > -	  <http://rt2x00.serialmonkey.com>
> > +	Copyright (C) 2009 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > +	Copyright (C) 2009 Ivo van Doorn <IvDoorn@gmail.com>
> > +	Copyright (C) 2009 Alban Browaeys <prahal@yahoo.com>
> > +	Copyright (C) 2009 Felix Fietkau <nbd@openwrt.org>
> > +	Copyright (C) 2009 Luis Correia <luis.f.correia@gmail.com>
> > +	Copyright (C) 2009 Mattias Nissler <mattias.nissler@gmx.de>
> > +	Copyright (C) 2009 Mark Asselstine <asselsm@gmail.com>
> > +	Copyright (C) 2009 Xose Vazquez Perez <xose.vazquez@gmail.com>
> > +	<http://rt2x00.serialmonkey.com>
> > +
> > +	Based on the original rt2800pci.c and rt2800usb.c.
> >  
> >  	This program is free software; you can redistribute it and/or modify
> >  	it under the terms of the GNU General Public License as published by
