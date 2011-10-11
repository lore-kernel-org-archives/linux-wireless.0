Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55791 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab1JKUpo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 16:45:44 -0400
Date: Tue, 11 Oct 2011 16:39:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bing Zhao <bzhao@marvell.com>, g@tuxdriver.com
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>
Subject: Re: [PATCH] mwifiex: add support for Marvell pcie8766 chipset
Message-ID: <20111011203936.GL6558@tuxdriver.com> (sfid-20111011_224548_354056_78678EF4)
References: <1317701303-21871-1-git-send-email-bzhao@marvell.com>
 <1317701303-21871-2-git-send-email-bzhao@marvell.com>
 <477F20668A386D41ADCC57781B1F704308155977E8@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F704308155977E8@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 06, 2011 at 08:30:53PM -0700, Bing Zhao wrote:
> Hi John,
> 
> > -----Original Message-----
> > From: Bing Zhao [mailto:bzhao@marvell.com]
> > Sent: Monday, October 03, 2011 9:08 PM
> > To: linux-wireless@vger.kernel.org
> > Cc: John W. Linville; Amitkumar Karwar; Kiran Divekar; Yogesh Powar; Frank Huang; Bing Zhao
> > Subject: [PATCH] mwifiex: add support for Marvell pcie8766 chipset
> > 
> > From: Amitkumar Karwar <akarwar@marvell.com>
> > 
> > This patch supports 88W8766P chipset with a PCIe interface.
> > 
> > The corresponding firmware image file is located at:
> > "mrvl/pcie8766_uapsta.bin"
> > 
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > Signed-off-by: Ramesh Radhakrishnan <rramesh@marvell.com>
> > Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
> > Signed-off-by: Kiran Divekar <dkiran@marvell.com>
> > Signed-off-by: Bing Zhao <bzhao@marvell.com>
> > Signed-off-by: Frank Huang <frankh@marvell.com>
> 
> Could you please apply this patch? It doesn't depend on the other patches we are working on.
> 
> Thanks,
> Bing

It generates warnings...

  LD [M]  drivers/net/wireless/mwifiex/mwifiex_pcie.o
WARNING: drivers/net/wireless/mwifiex/mwifiex_pcie.o(.data+0x18): Section mismatch in reference from the variable mwifiex_pcie to the variable .devinit.rodata:mwifiex_ids
The variable mwifiex_pcie references
the variable __devinitconst mwifiex_ids
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

WARNING: drivers/net/wireless/mwifiex/mwifiex_pcie.o(.data+0x20): Section mismatch in reference from the variable mwifiex_pcie to the function .devinit.text:mwifiex_pcie_probe()
The variable mwifiex_pcie references
the function __devinit mwifiex_pcie_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
