Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:39648 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757181AbZKWLF2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 06:05:28 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Subject: Re: [PATCH] b43: Rewrite DMA Tx status handling sanity checks
Date: Mon, 23 Nov 2009 12:05:30 +0100
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <200911192224.29491.mb@bu3sch.de> <200911231149.38494.mb@bu3sch.de> <5A2C6B7F-5617-49AA-B22A-A5574D6CD9FA@ing.unibs.it>
In-Reply-To: <5A2C6B7F-5617-49AA-B22A-A5574D6CD9FA@ing.unibs.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911231205.33093.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 23 November 2009 12:00:15 Francesco Gringoli wrote:
> Hi Michael,
> 
> so you can observe this behavior at your site. Do you mind describing  
> the exact configuration? Maybe this time I can reproduce this  
> behavior, as I tried everything to make it happen. I also asked Larry  
> one of his boards and put it into several PCs but had no chance to  
> reproduce the crash. Could you please also report the neighboring  
> stations, the AP you are connected and so on.

I don't reproduce this, because I never really tried running the opensource firmware.
Larry reproduced it, this time.

-- 
Greetings, Michael.
