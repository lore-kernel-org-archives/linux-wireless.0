Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:51563 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729691AbeHBKOZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Aug 2018 06:14:25 -0400
Date: Thu, 2 Aug 2018 13:54:15 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <venkateswara.kaja@microchip.com>, <ganesh.krishna@microchip.com>,
        <adham.abozaeid@microchip.com>, <aditya.shankar@microchip.com>
Subject: Re: [PATCH 3/8] staging: wilc1000: remove unnecessary copyright
 information in file
Message-ID: <20180802135415.17f126cc@ajaysk-VirtualBox> (sfid-20180802_102424_619160_B273BCE1)
In-Reply-To: <20180802073317.GA14107@kroah.com>
References: <1532844417-3192-1-git-send-email-ajay.kathat@microchip.com>
        <1532844417-3192-4-git-send-email-ajay.kathat@microchip.com>
        <20180802073317.GA14107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

On Thu, 2 Aug 2018 09:33:17 +0200
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Sun, Jul 29, 2018 at 11:36:52AM +0530, Ajay Singh wrote:
> > Cleanup patch to remove the unnecessary copyright information in
> > the file, as it already has SPDX License Identifier.
> > 
> > diff --git a/drivers/staging/wilc1000/wilc_debugfs.c
> > b/drivers/staging/wilc1000/wilc_debugfs.c index ac26e94..d86f457
> > 100644 --- a/drivers/staging/wilc1000/wilc_debugfs.c
> > +++ b/drivers/staging/wilc1000/wilc_debugfs.c
> > @@ -1,14 +1,4 @@
> >  // SPDX-License-Identifier: GPL-2.0
> > -/*
> > - * NewportMedia WiFi chipset driver test tools - wilc-debug
> > - * Copyright (c) 2012 NewportMedia Inc.
> > - * Author: SSW <sswd@wilcsemic.com>  
> 
> No, you can not just drop copyright lines for no reason at all.  Did
> your lawyers approve this patch?
> 

Actually, I had planned to keep Microchip Copyright header for these
files later, as currently these files has the previous
company copyright information. 
I am not sure what will be right practice to either keep all
previous companies copyright or only the latest copyright information.

Its better to drop this for now and after consulting internally I will
submit the new patch.


> SPDX identifes the _license_ of the file, not the copyrights, so it is
> ok to drop these lines:
> 
> > - *
> > - * This program is free software; you can redistribute it and/or
> > modify
> > - * it under the terms of the GNU General Public License version 2
> > as
> > - * published by the Free Software Foundation.  
> 
> As that is what it is replacing.  But not the copyrights.
> 
> Go show your lawyer this patch:
> 
> > --- a/drivers/staging/wilc1000/wilc_sdio.c
> > +++ b/drivers/staging/wilc1000/wilc_sdio.c
> > @@ -1,9 +1,4 @@
> >  // SPDX-License-Identifier: GPL-2.0
> > -/*
> > - * Copyright (c) Atmel Corporation.  All rights reserved.  
> 
> And see what they do :)
> 
> (yes, explicit copyright notices are really not needed and do not do
> "much", but it is still the norm that they are present and our
> industry does still rely on them...)
> 
> thanks,
> 
> greg k-h
