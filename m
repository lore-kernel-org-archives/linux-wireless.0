Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:45073 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750717AbaFJPmS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2014 11:42:18 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Chin-Ran Lo <crlo@marvell.com>, Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Andreas Fenkart <afenkart@gmail.com>
Date: Tue, 10 Jun 2014 08:41:57 -0700
Subject: RE: [PATCH 2/3] mwifiex: get rid of 'ethtool wol' code
Message-ID: <477F20668A386D41ADCC57781B1F70430FE1BF390F@SC-VEXCH1.marvell.com> (sfid-20140610_174221_344015_52AB7341)
References: <1402109264-7095-1-git-send-email-bzhao@marvell.com>
 <1402109264-7095-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1402109264-7095-2-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> "iw wowlan" command takes care all wake on wlan use cases.
> So we will remove older configuration option through 'ethtool'
> utility.

Please drop this patch.
As Andreas Fenkart pointed out, "ethtool wol p" option isn't covered by "iw wowlan" command and some users may still need "ethtool wol p" feature.

The other two patches 1/3 and 3/3 are still valid.

Thanks,
Bing

> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> ---
>  drivers/net/wireless/mwifiex/Makefile   |  1 -
>  drivers/net/wireless/mwifiex/cfg80211.c |  1 -
> drivers/net/wireless/mwifiex/ethtool.c  | 70 ---------------------------------
>  drivers/net/wireless/mwifiex/main.h     |  2 -
>  4 files changed, 74 deletions(-)
>  delete mode 100644 drivers/net/wireless/mwifiex/ethtool.c

