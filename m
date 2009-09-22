Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:61811 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbZIVXir (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2009 19:38:47 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: davem@davemloft.net, linville@tuxdriver.com,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-mmc@vger.kernel.org
Cc: yi.zhu@intel.com, inaky.perez-gonzalez@intel.com,
	cindy.h.kao@intel.com, guy.cohen@intel.com,
	ron.rindjunsky@intel.com
Subject: [PATCH 0/3 net] Add iwmc3200top driver
Date: Wed, 23 Sep 2009 02:38:41 +0300
Message-Id: <1253662724-16497-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwmc3200top: Add Intel Wireless MultiCom 3200 top driver.
iwmc3200wifi: select IWMC3200TOP in Kconfig
i2400m-sdio: select IWMC3200TOP in Kconfig

Add iwmc3200top driver. Imwc3200 is under drivers/misc driver but IMWC network 
drivers depends on it therefore submitted through netdev


---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

