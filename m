Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:51498 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab2ADS3R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jan 2012 13:29:17 -0500
Date: Wed, 04 Jan 2012 13:28:11 -0500 (EST)
Message-Id: <20120104.132811.1526508364584579293.davem@davemloft.net> (sfid-20120104_192920_681719_8D0486B9)
To: kvalo@qca.qualcomm.com
Cc: linville@tuxdriver.com, ath6kl-devel@qualcomm.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath6kl: force building as a module
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120104094134.28754.39652.stgit@x201>
References: <20120104094134.28754.39652.stgit@x201>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Wed, 04 Jan 2012 11:41:34 +0200

> Stephen reported that ath6kl fails if both sdio and usb are built
> into the kernel:
> 
> ath6kl/cfg80211.c:27:1: error: expected ')' before 'KBUILD_MODNAME'
> ath6kl/cfg80211.c:27:1: error: 'KBUILD_MODNAME' undeclared here (not in a function)
> ath6kl/cfg80211.c:27:1: error: expected ',' or ';' before string constant
> 
> As a temporary fix make ath6kl build only as a module. This will be reverted
> once a separate ath6kl core module is implemented which will fix this
> properly.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

NACK, fix this properly.
