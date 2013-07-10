Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:40718 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179Ab3GJJMS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jul 2013 05:12:18 -0400
Date: Wed, 10 Jul 2013 11:12:15 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "Jeffrey (Sheng-Hui) Chu" <jeffchu@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 
Message-ID: <20130710091215.GB12335@zurbaran> (sfid-20130710_111221_593514_7A18A455)
References: <90AC93A0CCA054488FFC508D6F62B6F40FED489B@IRVEXCHMB07.corp.ad.broadcom.com>
 <51DC0E91.2020604@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51DC0E91.2020604@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend, Jeffrey,

On Tue, Jul 09, 2013 at 03:22:25PM +0200, Arend van Spriel wrote:
> + Samuel
> 
> On 07/08/2013 11:52 PM, Jeffrey (Sheng-Hui) Chu wrote:
> > From b4555081b1d27a31c22abede8e0397f1d61fbb04 Mon Sep 17 00:00:00 2001
> >From: Jeffrey Chu <jeffchu@broadcom.com>
> >Date: Mon, 8 Jul 2013 17:50:21 -0400
> >Subject: [PATCH] Add bcm2079x-i2c driver for Bcm2079x NFC Controller.
> 
> The subject did not show in my mailbox. Not sure if necessary, but I
> tend to send patches to a maintainer and CC the appropriate list(s).
> So the nfc list as well (linux-nfc@lists.01.org).
Thanks for cc'ing me. Yes, the NFC maintainers emails and the mailing
list are in the MAINTAINERS file, so I expect people to use them to post
their NFC related patches.


> >---
> >  drivers/nfc/Kconfig                 |    1 +
> >  drivers/nfc/Makefile                |    1 +
> >  drivers/nfc/bcm2079x/Kconfig        |   10 +
> >  drivers/nfc/bcm2079x/Makefile       |    4 +
> >  drivers/nfc/bcm2079x/bcm2079x-i2c.c |  416 +++++++++++++++++++++++++++++++++++
> >  drivers/nfc/bcm2079x/bcm2079x.h     |   34 +++
> >  6 files changed, 466 insertions(+)
> >  create mode 100644 drivers/nfc/bcm2079x/Kconfig
> >  create mode 100644 drivers/nfc/bcm2079x/Makefile
> >  create mode 100644 drivers/nfc/bcm2079x/bcm2079x-i2c.c
> >  create mode 100644 drivers/nfc/bcm2079x/bcm2079x.h
Jeffrey, I appreciate the upstreaming effort, but I'm not going to take
this patch. It's designed for Android exclusively and not using any of
the NFC kernel APIs.
In particular, we have a full NCI stack that you could use. There
currently is an SPI transport layer, adding an i2c one would be really
easy.
If you're interested and can spend some cycles on this, I can surely
help you with the kernel APIs and how your driver should look like.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
