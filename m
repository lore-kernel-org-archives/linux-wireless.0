Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canuck.infradead.org ([209.217.80.40]:49129 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868AbXGLQJj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2007 12:09:39 -0400
Date: Thu, 12 Jul 2007 09:08:36 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: mb@bu3sch.de, Andrew Morton <akpm@linux-foundation.org>,
	John Linville <linville@tuxdriver.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	linux-wireless@vger.kernel.org,
	Gary Zambrano <zambrano@broadcom.com>
Subject: Re: [patch 2/2] ssb: Add a driver for the Broadcom OHCI core
Message-ID: <20070712160836.GB17912@kroah.com>
References: <20070712085432.528319000@bu3sch.de> <20070712085744.961584000@bu3sch.de> <20070712090459.ed76899c.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070712090459.ed76899c.rdunlap@xenotime.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 12, 2007 at 09:04:59AM -0700, Randy Dunlap wrote:
> On Thu, 12 Jul 2007 10:54:34 +0200 mb@bu3sch.de wrote:
> 
> > This adds a driver for the Broadcom USB OHCI HCD device.
> > These devices are found in various embedded Broadcom-47xx machines.
> 
> I would expect USB host drivers to be submitted to the
> linux-usb-devel@lists.sourceforge.net mailing list...

Yes, Michael, please submit this patch there for discussion.

thanks,

greg k-h
