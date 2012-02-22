Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27249 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab2BVJQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 04:16:08 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20292.45646.920030.685716@gargle.gargle.HOWL> (sfid-20120222_101625_964284_2382556E)
Date: Wed, 22 Feb 2012 14:45:58 +0530
To: Joe Perches <joe@perches.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH 25/26] ath9k_hw: MCI whitespace/debug cleanup
In-Reply-To: <1329899891.5143.34.camel@joe2Laptop>
References: <20292.38229.300584.953289@gargle.gargle.HOWL>
	<1329899891.5143.34.camel@joe2Laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches wrote:
> A for loop with a test/continue would reduce indentation.
> Might fix a bug too if timeout is ever negative.
> 
> 	for (; timeout > 0; udelay(10), timeout -= 10) {
> 		if (!(REG_READ(ah, address) & bit_position))
> 			continue;
> 		etc...

In subsequent patches :)

Sujith
