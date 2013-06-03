Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:38169 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3FCHlN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 03:41:13 -0400
Date: Mon, 03 Jun 2013 00:41:12 -0700 (PDT)
Message-Id: <20130603.004112.2164038601370585971.davem@davemloft.net> (sfid-20130603_094119_866151_7AEFEF03)
To: jg1.han@samsung.com
Cc: netdev@vger.kernel.org, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com, linville@tuxdriver.com,
	sgruszka@redhat.com, Larry.Finger@lwfinger.net,
	chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] net: wireless: replace strict_strtoul() with kstrtoul()
From: David Miller <davem@davemloft.net>
In-Reply-To: <000f01ce5e99$00617fc0$01247f40$@samsung.com>
References: <000f01ce5e99$00617fc0$01247f40$@samsung.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jingoo Han <jg1.han@samsung.com>
Date: Sat, 01 Jun 2013 16:24:06 +0900

> The usage of strict_strtoul() is not preferred, because
> strict_strtoul() is obsolete. Thus, kstrtoul() should be
> used.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Applied.
