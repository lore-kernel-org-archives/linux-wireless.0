Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gw-instruments.de ([82.144.60.34]:54254 "EHLO
	redbean.intranet.gw-instruments.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750944AbYLQLM0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 06:12:26 -0500
Date: Wed, 17 Dec 2008 12:09:46 +0100 (CET)
From: Peter Wippich <pewi@gw-instruments.de>
To: Andrey Yurovsky <andrey@cozybit.com>
cc: linux-wireless@vger.kernel.org, Colin McCabe <colin@cozybit.com>,
	libertas-dev@lists.infradead.org
Subject: Re: [PATCH 0/3] libertas: driver for GSPI devices
In-Reply-To: <45e8e6c40812160856k37cc7e44mc9f512baec0f888e@mail.gmail.com>
Message-ID: <Pine.LNX.4.63.0812171205520.7559@redbean.intranet.gw-instruments.de> (sfid-20081217_121231_669601_7124491C)
References: <1229398052-27465-1-git-send-email-colin@cozybit.com>
 <Pine.LNX.4.63.0812161654310.7559@redbean.intranet.gw-instruments.de>
 <45e8e6c40812160856k37cc7e44mc9f512baec0f888e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi Andrey, 

this is very recent. Good, so I can test it also here for our PXA 
implementation. If it gets publicly available it will help many embedded 
system implementers who  want to use the 8686. 

Chears, 

Peter 

On Tue, 16 Dec 2008, Andrey Yurovsky wrote:

> Hi Peter.  The firmware we used is fw 9.70.3p37 and its cap mask is 0x303.
> 
> We expect this firmware to be available for download soon.  Thanks,
> 
> On Tue, Dec 16, 2008 at 7:56 AM, Peter Wippich <pewi@gw-instruments.de> wrote:
> >
> > Hi Colin,
> >
> >> This patch series adds support for GSPI devices to libertas.
> >> These devices are found in some embedded systems. We used a blackfin-based
> >> board for development.
> >>
> >> Since the blackfin has specific alignment requirements, this patch set
> >> includes  alignment fixes.
> >
> > Thanks for this one. As you mentioned somewhere else SPI Firmware for 8686
> > is not publicly available. However, can you tell me with which firmware
> > Version you tested this ??
> >
> > Thank you and best regards,
> >
> > Peter
> >
> >
> > |       Peter Wippich                   Voice: +49 30 46776411          |
> > |       G&W Instruments GmbH            fax:   +49 30 46776419          |
> > |       Gustav-Meyer-Allee 25, Geb. 12  Email: pewi@gw-instruments.de   |
> > |       D-13355 Berlin  / Germany                                       |
> >
> >
> 
> 
> 
> -- 
> Andrey Yurovsky
> cozybit Inc.
> 
> _______________________________________________
> libertas-dev mailing list
> libertas-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/libertas-dev
> 


|       Peter Wippich                   Voice: +49 30 46776411          |
|       G&W Instruments GmbH            fax:   +49 30 46776419          |
|       Gustav-Meyer-Allee 25, Geb. 12  Email: pewi@gw-instruments.de   |
|       D-13355 Berlin  / Germany                                       |

