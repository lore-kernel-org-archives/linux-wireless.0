Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40371 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285Ab0LCCtS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 21:49:18 -0500
Received: by ywl5 with SMTP id 5so4533658ywl.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 18:49:17 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19704.23185.565826.890275@gargle.gargle.HOWL>
Date: Fri, 3 Dec 2010 08:18:49 +0530
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Sujith <m.sujith@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath9k_htc: Fix suspend/resume
In-Reply-To: <20101202193024.GC2358@tuxdriver.com>
References: <19701.62091.644444.121284@gargle.gargle.HOWL>
	<20101202193024.GC2358@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Wed, Dec 01, 2010 at 12:30:27PM +0530, Sujith wrote:
> > From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> > 
> > The HW has to be set to FULLSLEEP mode during suspend,
> > when no interface has been brought up. Not doing this would
> > break resume, as the chip won't be powered up at all.
> > 
> > Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> 
> Is this intended for 2.6.37?  It looks like it will apply there.

Thanks for pointing this out and yes, this would be a candidate for 2.6.37

Sujith
