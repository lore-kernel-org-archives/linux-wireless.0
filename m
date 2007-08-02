Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:52302
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbXHBOZV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 10:25:21 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] Merge the Sonics Silicon Backplane subsystem
Date: Thu, 2 Aug 2007 16:24:58 +0200
Cc: Andrew Morton <akpm@osdl.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Gary Zambrano <zambrano@broadcom.com>
References: <200707271857.24162.mb@bu3sch.de> <Pine.LNX.4.64.0708021557280.5150@anakin>
In-Reply-To: <Pine.LNX.4.64.0708021557280.5150@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708021624.59701.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 02 August 2007, Geert Uytterhoeven wrote:
> On Fri, 27 Jul 2007, Michael Buesch wrote:
> > The Sonics Silicon Backplane is a mini-bus used on
> > various Broadcom chips and embedded devices.
> > Devices using the SSB include b44, bcm43xx and various
> > Broadcom based wireless routers.
> > A b44 and bcm43xx port and a SSB based OHCI driver is available.
> 
> > --- a/drivers/Kconfig
> > +++ b/drivers/Kconfig
> > @@ -58,6 +58,8 @@ source "drivers/power/Kconfig"
> >  
> >  source "drivers/hwmon/Kconfig"
> >  
> > +source "drivers/ssb/Kconfig"
> > +
> >  source "drivers/mfd/Kconfig"
> >  
> >  source "drivers/media/Kconfig"
> 
> > --- /dev/null
> > +++ b/drivers/ssb/Kconfig
> > @@ -0,0 +1,92 @@
> > +menu "Sonics Silicon Backplane"
> > +
> > +config SSB
> > +	tristate "Sonics Silicon Backplane support"
> > +	depends on EXPERIMENTAL
> 
> Hence this will show up on all platforms?

So?
