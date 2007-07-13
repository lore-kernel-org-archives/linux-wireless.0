Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50557
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbXGMKYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2007 06:24:00 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Aurelien Jarno <aurelien@aurel32.net>
Subject: Re: [patch 1/2] Merge the Sonics Silicon Backplane subsystem
Date: Fri, 13 Jul 2007 12:22:35 +0200
Cc: Andrew Morton <akpm@linux-foundation.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Gary Zambrano <zambrano@broadcom.com>
References: <20070712085432.528319000@bu3sch.de> <20070712085744.604965000@bu3sch.de> <20070713061100.GA28974@hall.aurel32.net>
In-Reply-To: <20070713061100.GA28974@hall.aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200707131222.35550.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 13 July 2007 08:11:00 Aurelien Jarno wrote:
> On Thu, Jul 12, 2007 at 10:54:33AM +0200, mb@bu3sch.de wrote:
> > This merges the SSB subsystem. SSB is a backplane bus subsystem needed
> > for various Broadcom devices.
> > 
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> [...]
> 
> > Index: linux-2.6/include/linux/ssb/ssb_regs.h
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-2.6/include/linux/ssb/ssb_regs.h	2007-07-12 10:51:49.000000000 +0200
> > @@ -0,0 +1,294 @@
> 
> [...]
> 
> > +#define	SSB_EXTIF_BASE		0x1f000000	/* External Interface region base address */
> > +#define	SSB_FLASH1		0x1fc00000	/* Flash Region 1 */
> > +#define	SSB_FLASH1_SZ		0x00400000	/* Size of Flash Region 1 */
> > +
> > +#define SSB_PCI_DMA		0x40000000	/* Client Mode sb2pcitranslation2 (1 GB) */
> > +#define SSB_PCI_DMA_SZ		0x40000000	/* Client Mode sb2pcitranslation2 size in bytes */
> > +#define SSB_PCIE_DMA_L32		0x00000000	/* PCIE Client Mode sb2pcitranslation2 (2 ZettaBytes), low 32 bits */
> > +#define SSB_PCIE_DMA_H32		0x80000000	/* PCIE Client Mode sb2pcitranslation2 (2 ZettaBytes), high 32 bits */
> > +#define	SSB_EUART		(SB_EXTIF_BASE + 0x00800000)
> > +#define	SSB_LED			(SB_EXTIF_BASE + 0x00900000)
> 
> I have just noticed a typo here. That should be SSB_EXTIF_BASE instead
> of SB_EXTIF_BASE.
> 

Thanks, I fixed this.

-- 
Greetings Michael.
