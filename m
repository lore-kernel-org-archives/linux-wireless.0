Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47260 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761134AbZAMPAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 10:00:43 -0500
Date: Tue, 13 Jan 2009 09:52:14 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: tsr <tsr.offentlig@tsr.se>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Marvell 88w8385 Support
Message-ID: <20090113145213.GA3623@tuxdriver.com> (sfid-20090113_160056_154393_55E4D82A)
References: <496C8468.4060101@tsr.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <496C8468.4060101@tsr.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 13, 2009 at 01:09:12PM +0100, tsr wrote:
> Hi,
>
> I have a FSG-3 that includes a Marvell 88w8385 card. I wonder if there  
> is support for it in recent kernels. According to  
> http://marc.info/?l=linux-wireless&m=123178916308198&w=2 (search for  
> 8385) there seems to be support but I don't want to start messing around  
> with kernels and stuff without being sure.

That driver is for SDIO hardware.  It looks like your FSG-3 has
mini-PCI?  Either way, we don't have a driver merged yet that would
cover your hardware.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
