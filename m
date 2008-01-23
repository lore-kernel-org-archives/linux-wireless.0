Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2903 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104AbYAWPB7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 10:01:59 -0500
Date: Wed, 23 Jan 2008 09:52:43 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/14] RFC: Driver for Wireless RNDIS USB devices.
Message-ID: <20080123145243.GA3129@tuxdriver.com> (sfid-20080123_150234_109224_6231D6BB)
References: <20080120001342.25718.83669.stgit@fate.lan> <1201094475.7733.1.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1201094475.7733.1.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 23, 2008 at 03:21:15PM +0200, Jussi Kivilinna wrote:
> On Sun, 2008-01-20 at 02:13 +0200, Jussi Kivilinna wrote:
> > Hello,
> > 
> > This is second try on wireless RNDIS patchset started by Bjorge Dijkstra. Since
> > Bjorge has disappeared, I claim maintainership of rndis_wext and this patchset
> > until he returns.
> > 
> > This patchset adds support for various 802.11 USB devices based on Broadcom
> > 4320 chip. Chip uses RNDIS to communicate with the host, so module depend
> > heavily on rndis_host/cdc_ether/usbnet and needs some changes on these 
> > modules in order to work.

> Any change of getting driver merged in 2.6.25?

I would like to have this driver soon, and FWIW I just put it in the
Fedora Rawhide kernel last night.

However, I find that it does not seem to associate with WEP networks
on my USR5421.  I haven't had a chance to try it on open or WPA
networks, nor have I had a chance to debug it.  It does scan and see
the networks.

Have you tested the driver as posted?  What device(s) are you using?
Have you used it on encrypted networks?

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
