Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:60588 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932221Ab3GCVuR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 17:50:17 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Shuah Khan <shuah.kh@samsung.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"rjw@sisk.pl" <rjw@sisk.pl>, "hauke@hauke-m.de" <hauke@hauke-m.de>,
	"lars@metafoo.de" <lars@metafoo.de>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"shuahkhan@gmail.com" <shuahkhan@gmail.com>
Date: Wed, 3 Jul 2013 14:46:39 -0700
Subject: RE: [PATCH] wireless: Convert mwifiex/pcie to dev_pm_ops from
 legacy pm_ops
Message-ID: <477F20668A386D41ADCC57781B1F70430EA2E06715@SC-VEXCH1.marvell.com> (sfid-20130703_235053_483250_1CE727CF)
References: <1372870030-2596-1-git-send-email-shuah.kh@samsung.com>
In-Reply-To: <1372870030-2596-1-git-send-email-shuah.kh@samsung.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Convert the mwifiex/pci driver to use dev_pm_ops for power management and
> remove Legacy PM handling. This change re-uses existing suspend and resume
> interfaces for dev_pm_ops, and changes CONFIG_PM ifdefs to CONFIG_PM_SLEEP
> as the driver does not support run-time PM.
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

