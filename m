Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:60387 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbYLPDN0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 22:13:26 -0500
Date: Tue, 16 Dec 2008 04:13:25 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH,RFC] initial mwl8k driver for marvell topdog wireless
Message-ID: <20081216031325.GD21476@xi.wantstofly.org> (sfid-20081216_041336_592667_E12521BC)
References: <20081216025542.GO18056@xi.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081216025542.GO18056@xi.wantstofly.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 16, 2008 at 03:55:42AM +0100, Lennert Buytenhek wrote:

> Attached is an initial version of the mwl8k driver for Marvell 88w8xxx
> PCI/PCIe wireless parts (against 2.6.27.1).  This version was written
> and tested against the 88w8687 (802.11b/g), but it shouldn't be hard to
> extend the support to other parts in the 8xxx series, since the firmware
> interface is very similar between parts.
> 
> There's an occasional timeout warning with mwl8k_stop(), and hardware
> crypto is still a work-in-progress, but other than that it looks pretty
> stable.
> 
> Feedback appreciated!

I suppose the mail got eaten because the attachment trips the list's
post size limit, so I've uploaded a copy of the patch to:

	http://www.wantstofly.org/~buytenh/mwl8k.diff
