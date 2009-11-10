Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:44248 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbZKJJZF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 04:25:05 -0500
Subject: Re: [RFT 0/6] rtl8187se: Initial introduction of driver
From: Marcel Holtmann <marcel@holtmann.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, bzolnier@gmail.com,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4af8a56a.fCJY51VFS93aEZ0t%Larry.Finger@lwfinger.net>
References: <4af8a56a.fCJY51VFS93aEZ0t%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Nov 2009 10:25:03 +0100
Message-ID: <1257845103.26914.5.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

> Patches to introduce a driver for the RTL8187SE PCI-based device.
> 
> Note: This driver is only compile-tested and will require more work
> for it to be useful. I'm posting now to let others know what I have done.
> 
> I have applied for an account at kernel.org. If my request is approved, I
> plan to establish an rtl8187se git tree.
> 
> Patch 1/6: Create file rtl8187se.h
> Patch 2/6: Create file rtl8187se_dev.c
> Patch 3/6: Create file rtl8187se_rtl8225.c
> Patch 4/6: Create file rtl8187se_rtl8225.h
> Patch 5/6: Modify file rtl818x.h
> Patch 6/6: Modify Kconfig and Makefile for rtl8187se

so personally I don't think the split in a per file commit is helpful at
all. It adds no real value to the tree. For review and working around
the size limit of vger.kernel.org it is fine, but for the final merge I
prefer that all files are added in one commit.

Regards

Marcel


