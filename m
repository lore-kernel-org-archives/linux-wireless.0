Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:37558 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758045AbYBPAW4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 19:22:56 -0500
Date: Sat, 16 Feb 2008 08:22:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Adam Turk <bofh1234@hotmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: kernel 2.6.25-rc1 and no /dev/rt73usb
Message-ID: <20080216002252.GD19209@gondor.apana.org.au> (sfid-20080216_002300_349716_AE82488A)
References: <BAY101-W101FB386E1EF7402881964C8260@phx.gbl> <20080215050358.GA10363@gondor.apana.org.au> <BAY101-W21A064889BC2442893B63BC8260@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BAY101-W21A064889BC2442893B63BC8260@phx.gbl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 15, 2008 at 03:27:51PM -0500, Adam Turk wrote:
> 
> > You need to enable KMOD. Otherwise you must manually preload
> > the relevant modules.
> 
> I thought that was what udev was for?  Anyway I recompiled with KMOD enabled and I have partial success.  I nolonger get any errors when I plug in my wireless card.  

No udev provides auto-loading for device drivers of e.g., PCI
devices.  KMOD loads things like network protocols or crypto
algorithms that are not device-backed.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
