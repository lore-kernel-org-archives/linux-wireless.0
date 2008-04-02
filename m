Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:51789 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbYDBNsZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 09:48:25 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ssb-pcmcia: IRQ and DMA related fixes
Date: Wed, 2 Apr 2008 15:47:56 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <200803281034.55731.mb@bu3sch.de> <20080401192733.GA17630@tuxdriver.com>
In-Reply-To: <20080401192733.GA17630@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804021547.56480.mb@bu3sch.de> (sfid-20080402_144828_460399_462BE62E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 01 April 2008 21:27:33 John W. Linville wrote:
> On Fri, Mar 28, 2008 at 10:34:55AM +0100, Michael Buesch wrote:
> > Here come some IRQ and DMA related fixes for the ssb PCMCIA-host code.
> > Not much to say, actually. I think the patch explains itself.
> > 
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> > 
> > ---
> > 
> > For 2.6.25
> 
> This seems to build upon these two patches:
> 
> commit e7ec2e3230633a858af1b0b359f6c4670dbeb997
> Author: Michael Buesch <mb@bu3sch.de>
> Date:   Mon Mar 10 17:26:32 2008 +0100
> 
>     ssb: Add SPROM/invariants support for PCMCIA devices
> 
>     This adds support for reading/writing the SPROM invariants
>     for PCMCIA based devices.
> 
>     Signed-off-by: Michael Buesch <mb@bu3sch.de>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> commit ffc7689ddae5cbe12bde437ae0f2b386d568b5cd
> Author: Michael Buesch <mb@bu3sch.de>
> Date:   Wed Feb 20 19:08:10 2008 +0100
> 
>     ssb: Add support for 8bit register access
> 
>     This adds support for 8bit wide register reads/writes.
>     This is needed in order to support the gigabit ethernet core.
> 
>     Signed-off-by: Michael Buesch <mb@bu3sch.de>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> Those are not in 2.6.25.  Is 2.6.26 OK for this one?

Yeah, right. I was a little bit confused what was in 2.6.25 :)


-- 
Greetings Michael.
