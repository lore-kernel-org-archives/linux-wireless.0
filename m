Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:59025 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbZBYCrg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 21:47:36 -0500
Date: Wed, 25 Feb 2009 03:47:34 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH,RFC] initial mwl8k driver for marvell topdog wireless
Message-ID: <20090225024734.GF17040@xi.wantstofly.org> (sfid-20090225_034743_787498_AACAEAF0)
References: <20081216025542.GO18056@xi.wantstofly.org> <4963552D.40808@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4963552D.40808@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 06, 2009 at 01:57:17PM +0100, Jan Kiszka wrote:

> > Attached is an initial version of the mwl8k driver for Marvell 88w8xxx
> > PCI/PCIe wireless parts (against 2.6.27.1).  This version was written
> > and tested against the 88w8687 (802.11b/g), but it shouldn't be hard to
> > extend the support to other parts in the 8xxx series, since the firmware
> > interface is very similar between parts.
> 
> I guess 88w8xxx will not include 88w8618 on day, will it? That's an
> ARM-based SoC with integrated b/g-WLAN. Are there chances to reuse parts
> of this driver for that controller or are they totally different?

I'm not aware of any plans to do so, and I'm not sure anyone is
working on 88w8618 support at the moment.  As to whether it's similar
-- sorry, I don't know off the top of my head.
