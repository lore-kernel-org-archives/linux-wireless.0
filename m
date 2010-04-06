Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53266 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab0DFTpI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 15:45:08 -0400
Date: Tue, 6 Apr 2010 15:34:09 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, users@rt2x00.serialmonkey.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/4] rt2x00: Powersave fixes.
Message-ID: <20100406193409.GA3017@tuxdriver.com>
References: <1269985826-17438-1-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1269985826-17438-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 30, 2010 at 11:50:22PM +0200, Gertjan van Wingerde wrote:
> The following 4 patches fix powersave behavior of rt2x00.
> The first patch fixes the rt2500usb powersave issues found lately.
> The second on enables powersave for rt2500usb again, now it is fixed.
> The third and fourth are ongoing work to bring the other PCI drivers
> in a better shape.
> 
> All patches are against wireless-2.6.
> 
> The patch series is also available via:
> 
> 	git://git.gwingerde.nl/rt2x00-2.6.git
> 
> Gertjan van Wingerde (4):
>   rt2x00: Disable auto wakeup before waking up device.
>   rt2x00: Enable powersaving by default again on rt2500usb.
>   rt2x00: Add wakeup interrupt handler to rt61pci.
>   rt2x00: Add wakeup interrupt handler to rt2800pci.

I don't have any objection to these patches, but they don't
seem appropriate for 2.6.34 to me.  As such, basing them on
wireless-next-2.6 seems more appropriate.

Any objection to me applying them for 2.6.35?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
