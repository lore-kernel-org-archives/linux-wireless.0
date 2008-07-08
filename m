Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:42225 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757766AbYGHRFJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 13:05:09 -0400
From: Michael Buesch <mb@bu3sch.de>
To: sbrown@cortland.com
Subject: Re: [PATCH] ssb, b43, b43legacy, b44: Rewrite SSB DMA API
Date: Tue, 8 Jul 2008 19:04:42 +0200
Cc: Felipe Maya <felipe.maya@vexcorp.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <200806201150.29497.mb@bu3sch.de> <200807032252.35662.mb@bu3sch.de> <48738EC2.1060402@cortland.com>
In-Reply-To: <48738EC2.1060402@cortland.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807081904.42837.mb@bu3sch.de> (sfid-20080708_190530_605120_16DADA81)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 08 July 2008 17:58:58 Steve Brown wrote:
> I'll post the problem to linux-mips.

Please do so. This really is a DMA API issue. It's either using the masks
incorrectly, or ot should provide a function to set the coherent mask.

SSB does use The Right (TM) API. So it should not break, in my opinion.
I'm fully aware, that there is no non-PCI function that sets the coherent
mask. But I really expected that nobody is using it for non-PCI devices
either.

-- 
Greetings Michael.
