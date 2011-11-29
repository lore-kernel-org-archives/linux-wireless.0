Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:42413 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449Ab1K2Tig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 14:38:36 -0500
Date: Tue, 29 Nov 2011 14:41:33 -0500 (EST)
Message-Id: <20111129.144133.169090345.davem@davemloft.net> (sfid-20111129_203855_313114_ECD27488)
To: mcgrof@qca.qualcomm.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: [PATCH] prism54: remove private driver ioctls
From: David Miller <davem@davemloft.net>
In-Reply-To: <1322588416-15398-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1322588416-15398-1-git-send-email-mcgrof@qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Tue, 29 Nov 2011 12:40:16 -0500

> As of hostap_0_7_1~358 the CONFIG_DRIVER_PRISM54
> was removed from upstream wpa_supplicant/hostapd so
> lets just kill the useless old prism54 private ioctl
> crap.
> 
> Cc: Jouni Malinen <j@w1.fi>
> Cc: David Miller <davem@davemloft.net>
> Reported-by: David Miller <davem@davemloft.net>
> Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

Thanks for taking care of this.
