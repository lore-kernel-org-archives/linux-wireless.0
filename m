Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:35952 "HELO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965205Ab1JFVXD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 17:23:03 -0400
From: Bing Zhao <bzhao@marvell.com>
To: David Woodhouse <dwmw2@infradead.org>,
	David Woodhouse <David.Woodhouse@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 0/2] linux-firmware: firmware images for mwifiex driver
Date: Thu,  6 Oct 2011 14:20:26 -0700
Message-Id: <1317936028-28164-1-git-send-email-bzhao@marvell.com> (sfid-20111006_232308_186009_17E9B623)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,

These two patches update/add sd8787/pcie8766 firmware images
used by mwifiex driver.

Thanks,
Bing


Bing Zhao (2):
  linux-firmware: update Marvell SD8787 firmware image
  linux-firmware: add Marvell PCIe8766 firmware image

 WHENCE                   |    5 ++++-
 mrvl/pcie8766_uapsta.bin |  Bin 0 -> 294064 bytes
 mrvl/sd8787_uapsta.bin   |  Bin 354796 -> 359836 bytes
 3 files changed, 4 insertions(+), 1 deletions(-)
 create mode 100644 mrvl/pcie8766_uapsta.bin

-- 
1.7.4.1

