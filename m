Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:59544 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab0JHFA6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 01:00:58 -0400
Subject: Re: [PATCH v2 00/11] SDIO Runtime PM Support
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Chris Ball <cjb@laptop.org>
Cc: ext Ohad Ben-Cohen <ohad@wizery.com>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Nicolas Pitre <nico@fluxnic.net>
In-Reply-To: <20101007180107.GA15745@void.printf.net>
References: <1286020455-28946-1-git-send-email-ohad@wizery.com>
	 <1286454736.27371.37.camel@chilepepper>
	 <20101007180107.GA15745@void.printf.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 08:00:50 +0300
Message-ID: <1286514050.1662.58.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-07 at 20:01 +0200, ext Chris Ball wrote:
> Hi Luciano, Ohad,
> 
> On Thu, Oct 07, 2010 at 03:32:16PM +0300, Luciano Coelho wrote:
> > I have tested this on my beagle board with the wl1271 patches that Ohad
> > provided and it seems to be working fine.  I've also created a small
> > script to stress test the implementation a little bit and didn't see any
> > problems.
> > 
> > Tested-by: Luciano Coelho <luciano.coelho@nokia.com>
> > 
> > This is quite an important fix in the wl1271 point-of-view.  Chris, do
> > you think there is any chance that this could make it to 2.6.37?
> 
> Yes, can do -- the patchset looks good, and I've just pushed patches
> 1-9 (the MMC patches) to mmc-next.  Please go ahead and submit the
> two wl1271 patches through wireless-testing whenever you're ready.

Thanks a lot, Chris! This will easy our development work quite much,
since we don't have to be applying separate patches to be able to enable
and disable the chip at runtime.

I'll apply the wl1271 patches via the wl12xx tree.

-- 
Cheers,
Luca.

