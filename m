Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:33704 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbZEOUzO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 16:55:14 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 1/2 V2] b43legacy: Remove unnecessary MMIO in interrupt hotpath
Date: Fri, 15 May 2009 22:53:56 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	wireless <linux-wireless@vger.kernel.org>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
References: <4A0DD2F8.2070804@lwfinger.net>
In-Reply-To: <4A0DD2F8.2070804@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200905152253.56339.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 15 May 2009 22:39:20 Larry Finger wrote:
> From: Stefano Brivio <stefano.brivio@polimi.it>
> 
> This removes unnecessary MMIO accesses in the interrupt hotpath. The
> patch by Michael Buesch for b43 has been ported to b43legacy.
> 
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> This is 2.6.31 material. I am submitting this for Stefano because
> this patch touches a section of the code that had to be changed
> to fix a locking problem.
> 
> I hope this patch does not cause any problems. My normal method
> is not available while I'm away from home.
> 
> V2 does not try to eliminate any "unused" DMA rings. If any should be
> eliminated, that will be in a separate patch.

ACK

-- 
Greetings, Michael.
