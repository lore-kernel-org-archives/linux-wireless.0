Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39504 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906Ab1BKAxV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 19:53:21 -0500
Date: Thu, 10 Feb 2011 19:52:51 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH for-2.6.38] p54pci: update receive dma buffers before and
 after processing
Message-ID: <20110211005250.GF1553@tuxdriver.com>
References: <201102110148.43155.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <201102110148.43155.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 11, 2011 at 01:48:42AM +0100, Christian Lamparter wrote:
> Documentation/DMA-API-HOWTO.txt states:
> 
> "DMA transfers need to be synced properly in order for
> the cpu and device to see the most uptodate and correct
> copy of the DMA buffer."
> 
> Cc: <stable@kernel.org>
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
> Embarrassingly, this bug is unique to p54 and has been around
> since 2.6.25. This tells us something interesting about our
> userbase.

Most likely it tells us that most people using p54 are using little
endian boxes with coherent DMA... :-)

John
-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
