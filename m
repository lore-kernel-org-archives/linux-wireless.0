Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:59362 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbaKKXgr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 18:36:47 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21602.40415.179942.572517@gargle.gargle.HOWL> (sfid-20141112_004403_254198_A5E475B4)
Date: Wed, 12 Nov 2014 05:08:06 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: Miaoqing Pan <miaoqing@qca.qualcomm.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH 4/6] ath9k: Fix high tx power in multi-chain mode
In-Reply-To: <54621BFF.7080709@openwrt.org>
References: <1415689644-29693-1-git-send-email-sujith@msujith.org>
	<1415689644-29693-5-git-send-email-sujith@msujith.org>
	<54621BFF.7080709@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> That doesn't seem right to me. ah->caps.tx_chainmask is not altered
> based on software antenna configuration.

Yes, that's true.

Miaoqing, can you clarify ? Should the thermometer for chain 1 be
enabled even though the HW caps contain 0x1 as TX chainmask, for example ?
Are there such boards ?

Sujith
