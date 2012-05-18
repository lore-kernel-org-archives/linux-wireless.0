Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57018 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479Ab2ERPt1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 11:49:27 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20406.28492.196848.41247@gargle.gargle.HOWL> (sfid-20120518_174938_860743_53E14062)
Date: Fri, 18 May 2012 21:18:28 +0530
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 05/10] ath9k_hw: add AR9462 initval for Global WLAN, BT settings
In-Reply-To: <1337350053-15491-5-git-send-email-rmanohar@qca.qualcomm.com>
References: <1337350053-15491-1-git-send-email-rmanohar@qca.qualcomm.com>
	<1337350053-15491-5-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> +static const u32 ar9462_2p0_glb_wlan_bt[][2] = {
> +	/* Addr      allmodes  */
> +	{0x0002002c, 0x00000003},
> +};
> +

Since this is just a single register, it would be much simpler to
just program it directly instead of having an initval array.

Sujith
