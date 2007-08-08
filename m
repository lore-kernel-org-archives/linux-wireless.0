Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.ocgnet.org ([64.20.243.3]:56095 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759596AbXHHXOl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 19:14:41 -0400
Date: Thu, 9 Aug 2007 08:13:44 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: Re: superh allmodconfig
Message-ID: <20070808231344.GA22446@linux-sh.org>
References: <20070808160619.1b483888.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070808160619.1b483888.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 08, 2007 at 04:06:19PM -0700, Andrew Morton wrote:
> drivers/net/b44.c: In function `b44_sync_dma_desc_for_cpu':
> drivers/net/b44.c:159: error: implicit declaration of function `dma_sync_single_range_for_cpu'
> 
> This is actually an sh problem.  It hit sparc64 too but davem fixed
> it.  Seems that secveral architectures are lagging a bit in the PCI
> API area, and b44 is using things whcih other drivers are not.

I'll fix it up, thanks.
