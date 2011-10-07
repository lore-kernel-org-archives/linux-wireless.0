Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:32903 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935808Ab1JGDdG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 23:33:06 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Thu, 6 Oct 2011 20:30:53 -0700
Subject: RE: [PATCH] mwifiex: add support for Marvell pcie8766 chipset
Message-ID: <477F20668A386D41ADCC57781B1F704308155977E8@SC-VEXCH1.marvell.com> (sfid-20111007_053310_690482_AB561D87)
References: <1317701303-21871-1-git-send-email-bzhao@marvell.com>
 <1317701303-21871-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1317701303-21871-2-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> -----Original Message-----
> From: Bing Zhao [mailto:bzhao@marvell.com]
> Sent: Monday, October 03, 2011 9:08 PM
> To: linux-wireless@vger.kernel.org
> Cc: John W. Linville; Amitkumar Karwar; Kiran Divekar; Yogesh Powar; Frank Huang; Bing Zhao
> Subject: [PATCH] mwifiex: add support for Marvell pcie8766 chipset
> 
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> This patch supports 88W8766P chipset with a PCIe interface.
> 
> The corresponding firmware image file is located at:
> "mrvl/pcie8766_uapsta.bin"
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Ramesh Radhakrishnan <rramesh@marvell.com>
> Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
> Signed-off-by: Kiran Divekar <dkiran@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> Signed-off-by: Frank Huang <frankh@marvell.com>

Could you please apply this patch? It doesn't depend on the other patches we are working on.

Thanks,
Bing
