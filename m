Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10661 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab2BMNH2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 08:07:28 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20281.2825.452067.834075@gargle.gargle.HOWL> (sfid-20120213_140732_402909_F39F2357)
Date: Mon, 13 Feb 2012 18:37:21 +0530
To: Felix Fietkau <nbd@openwrt.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH 1/7] ath9k: Remove redundant max_streams assignment
In-Reply-To: <4F38F303.3010007@openwrt.org>
References: <20280.43934.3990.442268@gargle.gargle.HOWL>
	<4F38F303.3010007@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> I think AR9462 is also matched by AR_SREV_9300_20_OR_LATER(ah), so that
> one may not be redundant.

Ah, nice catch.

John, can you please drop this patch ?

Sujith
