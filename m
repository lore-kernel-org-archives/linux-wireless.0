Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40713 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbZKJNpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 08:45:16 -0500
Date: Tue, 10 Nov 2009 08:34:33 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, bzolnier@gmail.com,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFT 0/6] rtl8187se: Initial introduction of driver
Message-ID: <20091110133433.GB12682@tuxdriver.com>
References: <4af8a56a.fCJY51VFS93aEZ0t%Larry.Finger@lwfinger.net> <1257845103.26914.5.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1257845103.26914.5.camel@violet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 10, 2009 at 10:25:03AM +0100, Marcel Holtmann wrote:
> Hi Larry,
> 
> > Patches to introduce a driver for the RTL8187SE PCI-based device.
> > 
> > Note: This driver is only compile-tested and will require more work
> > for it to be useful. I'm posting now to let others know what I have done.
> > 
> > I have applied for an account at kernel.org. If my request is approved, I
> > plan to establish an rtl8187se git tree.
> > 
> > Patch 1/6: Create file rtl8187se.h
> > Patch 2/6: Create file rtl8187se_dev.c
> > Patch 3/6: Create file rtl8187se_rtl8225.c
> > Patch 4/6: Create file rtl8187se_rtl8225.h
> > Patch 5/6: Modify file rtl818x.h
> > Patch 6/6: Modify Kconfig and Makefile for rtl8187se
> 
> so personally I don't think the split in a per file commit is helpful at
> all. It adds no real value to the tree. For review and working around
> the size limit of vger.kernel.org it is fine, but for the final merge I
> prefer that all files are added in one commit.

Yes, I agree.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
