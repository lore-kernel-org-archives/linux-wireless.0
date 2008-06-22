Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:58179 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbYFVRDO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2008 13:03:14 -0400
Date: Sun, 22 Jun 2008 09:59:59 -0700
From: Greg KH <greg@kroah.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: stable@kernel.org, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de
Subject: Re: [stable] [PATCH stable] b43legacy: Fix possible NULL pointer
	dereference in DMA code
Message-ID: <20080622165959.GA18163@kroah.com> (sfid-20080622_190317_243137_26A93243)
References: <200806201146.12984.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200806201146.12984.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 20, 2008 at 11:46:12AM +0200, Michael Buesch wrote:
> This fixes a possible NULL pointer dereference in an error path of the
> DMA allocation error checking code.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> This patch is not merged to an upstream tree, yet, but is sent to John.

In the future, if you want patches to get automatically added to stable
when they go into Linus's tree, just add:
	Cc: stable <stable@kernel.org>

to the "Signed-off-by:" area and we will get notified of it at merge
time, so you don't have to resend it after it gets applied.

thanks,

greg k-h
