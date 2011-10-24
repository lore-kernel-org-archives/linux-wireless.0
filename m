Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:33207 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754355Ab1JXVbQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Oct 2011 17:31:16 -0400
From: Bing Zhao <bzhao@marvell.com>
To: David Woodhouse <dwmw2@infradead.org>,
	David Woodhouse <David.Woodhouse@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Mon, 24 Oct 2011 14:28:57 -0700
Subject: RE: [PATCH 0/2] linux-firmware: firmware images for mwifiex driver
Message-ID: <477F20668A386D41ADCC57781B1F70430817F5A356@SC-VEXCH1.marvell.com> (sfid-20111024_233129_735097_940DEF80)
References: <1317936028-28164-1-git-send-email-bzhao@marvell.com>
In-Reply-To: <1317936028-28164-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,

> -----Original Message-----
> From: Bing Zhao [mailto:bzhao@marvell.com]
> Sent: Thursday, October 06, 2011 2:20 PM
> To: David Woodhouse; David Woodhouse
> Cc: linux-wireless@vger.kernel.org; John W. Linville; Amitkumar Karwar; Yogesh Powar; Kiran Divekar;
> Frank Huang; Bing Zhao
> Subject: [PATCH 0/2] linux-firmware: firmware images for mwifiex driver
> 
> Hi David,
> 
> These two patches update/add sd8787/pcie8766 firmware images
> used by mwifiex driver.
> 
> Thanks,
> Bing
> 
> 
> Bing Zhao (2):
>   linux-firmware: update Marvell SD8787 firmware image
>   linux-firmware: add Marvell PCIe8766 firmware image

Could you please apply these two patches?
Please kindly let me know if there is any issue with the patches. 

Thanks,
Bing

> 
>  WHENCE                   |    5 ++++-
>  mrvl/pcie8766_uapsta.bin |  Bin 0 -> 294064 bytes
>  mrvl/sd8787_uapsta.bin   |  Bin 354796 -> 359836 bytes
>  3 files changed, 4 insertions(+), 1 deletions(-)
>  create mode 100644 mrvl/pcie8766_uapsta.bin
> 
> --
> 1.7.4.1

