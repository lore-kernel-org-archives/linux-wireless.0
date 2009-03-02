Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:54629 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbZCBRRo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 12:17:44 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for March 2 (wireless/b43)
Date: Mon, 2 Mar 2009 18:17:12 +0100
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
References: <20090302182217.90ca3356.sfr@canb.auug.org.au> <49AC0FAB.6000604@oracle.com>
In-Reply-To: <49AC0FAB.6000604@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903021817.12441.mb@bu3sch.de> (sfid-20090302_181748_475128_96608726)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 02 March 2009 17:56:11 Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20090227:
> > 
> > Undropped trees:
> > 	wireless
> 
> when CONFIG_SSB_DRIVER_PCICORE=n:
> 
>         if ((bus->bustype == SSB_BUSTYPE_PCI) &&
>             (bus->pcicore.dev->id.revision <= 10))
>                 hf |= B43_HF_PCISCW; /* PCI slow clock workaround. */
> 
> ==>
> drivers/net/wireless/b43/main.c:4182: error: 'struct ssb_pcicore' has no member named 'dev'
> 
> 
> 
> 

I'll send a fix asap.

-- 
Greetings, Michael.
