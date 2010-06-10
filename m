Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:24920 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759417Ab0FJSEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 14:04:14 -0400
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
To: linux-wireless@vger.kernel.org
Subject: Re: Support for the Linksys WUSB300N?
Date: Thu, 10 Jun 2010 12:04:11 -0600
Cc: "John W. Linville" <linville@tuxdriver.com>
References: <201006100653.48734.tfjellstrom@shaw.ca> <20100610141526.GC28553@tuxdriver.com>
In-Reply-To: <20100610141526.GC28553@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006101204.11538.tfjellstrom@shaw.ca>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On June 10, 2010, John W. Linville wrote:
> On Thu, Jun 10, 2010 at 06:53:48AM -0600, Thomas Fjellstrom wrote:
> > I have recently acquired a WUSB300N, and was wondering what the status
> > is on linux support for this device.
> > 
> > It's chipset (Marvell 88w8362) seems to be supported, but over PCI/PCIe
> > only so far. Is anyone working on USB variants? I'm willing to help
> > test anything anyone might be working on.
> 
> I'm not aware of anything in progress for this. :-(  In fact, even the
> PCI variant seems to mostly be getting random maintenance (e.g. API
> changes) from the community rather than any support from Marvell.
> 
> John

Thats too bad. Well I did get the thing for free. So theres noone at all 
working on this chipset specifically? Is there any information/documentation 
available? It might be interesting to see if I can manage to hack something 
together (total kernel programming n00b, but I do C relatively well).

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
