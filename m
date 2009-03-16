Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44698 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbZCPSPg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 14:15:36 -0400
Date: Mon, 16 Mar 2009 14:08:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Adrian Bassett <adrian.bassett@hotmail.co.uk>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rtl8180 Bit Rate regression in 2.6.29
Message-ID: <20090316180832.GC3660@tuxdriver.com> (sfid-20090316_191540_155947_775F33A2)
References: <COL113-W348B209977311F6BB460ADCB9B0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <COL113-W348B209977311F6BB460ADCB9B0@phx.gbl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 16, 2009 at 12:22:50PM +0000, Adrian Bassett wrote:
> 
> 
> (I'm not currently subscribed so please Cc: in any response ...)
> 
> Using PCI device 1799:700f and the rtl8180 kernel wireless driver.
> 
> With the vanilla 2.6.29-rc releases (rc8 most recently but also with predecessors) I've noticed that the Bit Rate of my wireless device appears to be more or less fixed at 1 Mb/s.  Occasionally, iwconfig reports higher values but, as the stats below show, no attempts are successful at higher Bit Rates with this kernel version.
> 
> With the 2.6.28 series, however, the Bit Rate will vary in the normal way, with the majority of the network activity happening at the higher end, if not the highest(54 Mb /s) point, of the range supported by this device.
> 
> This is using the minstrel rate control mechanism.

FWIW, are you sure?  PID was still the default in 2.6.28 IIRC.
The "run to the highest available rate" behavior was typical of PID.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
