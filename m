Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4824 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbXJAVIN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2007 17:08:13 -0400
Date: Mon, 1 Oct 2007 16:47:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: John Pierce <john.j35@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Belkin Wireless G USB
Message-ID: <20071001204756.GD5224@tuxdriver.com>
References: <aa73b9a0709281310w6030e0f5g4e3195cf800b5e7d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <aa73b9a0709281310w6030e0f5g4e3195cf800b5e7d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 28, 2007 at 03:10:34PM -0500, John Pierce wrote:

> This is the output of dmesg immediately after inserting the usb adapter.
> 
> usb 2-2: new high speed USB device using ehci_hcd and address 7
> usb 2-2: configuration #1 chosen from 1 choice
> usb 2-2: reset high speed USB device using ehci_hcd and address 7
> wmaster0: Failed to select rate control algorithm
> wmaster0: Failed to initialize rate control algorithm
> usb 2-2: reset high speed USB device using ehci_hcd and address 7
> zd1211rw_mac80211: probe of 2-2:1.0 failed with error -2
> usbcore: registered new interface driver zd1211rw_mac80211

You may want to move this to bugzilla.redhat.com.

As a first check, did you install the zd1211-firmware package?

John
-- 
John W. Linville
linville@tuxdriver.com
