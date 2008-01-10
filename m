Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3198 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757682AbYAJPvM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 10:51:12 -0500
Date: Thu, 10 Jan 2008 10:20:49 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Remove PIO support
Message-ID: <20080110152049.GA3109@tuxdriver.com> (sfid-20080110_155117_714311_81076A7C)
References: <200712261441.30437.mb@bu3sch.de> <1199901493.6762.32.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1199901493.6762.32.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 09, 2008 at 06:58:12PM +0100, Johannes Berg wrote:
> John,
> 
> On Wed, 2007-12-26 at 14:41 +0100, Michael Buesch wrote:
> > Remove b43 PIO support.
> > DMA works well on all supported devices. There's no reason to use PIO.
> > Additionally, new devices don't support PIO in hardware anymore.
> > b43 PIO support is dead and unused code.
> 
> You merged this patch, but
> 
> > After applying this patch please do
> > git rm drivers/net/wireless/b43/pio.h
> > git rm drivers/net/wireless/b43/pio.c
> > to remove the main PIO support code.
> 
> forgot this.

You're right -- thanks for the reminder!

-- 
John W. Linville
linville@tuxdriver.com
