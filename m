Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3788 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488AbYDATde (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 15:33:34 -0400
Date: Tue, 1 Apr 2008 15:27:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb-pcmcia: IRQ and DMA related fixes
Message-ID: <20080401192733.GA17630@tuxdriver.com> (sfid-20080401_203339_653198_54245146)
References: <200803281034.55731.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200803281034.55731.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 28, 2008 at 10:34:55AM +0100, Michael Buesch wrote:
> Here come some IRQ and DMA related fixes for the ssb PCMCIA-host code.
> Not much to say, actually. I think the patch explains itself.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> For 2.6.25

This seems to build upon these two patches:

commit e7ec2e3230633a858af1b0b359f6c4670dbeb997
Author: Michael Buesch <mb@bu3sch.de>
Date:   Mon Mar 10 17:26:32 2008 +0100

    ssb: Add SPROM/invariants support for PCMCIA devices

    This adds support for reading/writing the SPROM invariants
    for PCMCIA based devices.

    Signed-off-by: Michael Buesch <mb@bu3sch.de>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit ffc7689ddae5cbe12bde437ae0f2b386d568b5cd
Author: Michael Buesch <mb@bu3sch.de>
Date:   Wed Feb 20 19:08:10 2008 +0100

    ssb: Add support for 8bit register access

    This adds support for 8bit wide register reads/writes.
    This is needed in order to support the gigabit ethernet core.

    Signed-off-by: Michael Buesch <mb@bu3sch.de>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Those are not in 2.6.25.  Is 2.6.26 OK for this one?

John
-- 
John W. Linville
linville@tuxdriver.com
