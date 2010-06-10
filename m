Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44350 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759241Ab0FJOaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 10:30:10 -0400
Date: Thu, 10 Jun 2010 10:15:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Support for the Linksys WUSB300N?
Message-ID: <20100610141526.GC28553@tuxdriver.com>
References: <201006100653.48734.tfjellstrom@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201006100653.48734.tfjellstrom@shaw.ca>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 10, 2010 at 06:53:48AM -0600, Thomas Fjellstrom wrote:
> I have recently acquired a WUSB300N, and was wondering what the status is on 
> linux support for this device.
> 
> It's chipset (Marvell 88w8362) seems to be supported, but over PCI/PCIe only 
> so far. Is anyone working on USB variants? I'm willing to help test anything 
> anyone might be working on.

I'm not aware of anything in progress for this. :-(  In fact, even the
PCI variant seems to mostly be getting random maintenance (e.g. API
changes) from the community rather than any support from Marvell.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
