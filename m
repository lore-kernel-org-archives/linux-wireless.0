Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:50476 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab3LRLbQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 06:31:16 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21169.34397.50727.31496@gargle.gargle.HOWL> (sfid-20131218_123119_425664_1D6A15F4)
Date: Wed, 18 Dec 2013 16:56:21 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 07/10] ath9k: Remove ath9k_hw_gettsf32()
In-Reply-To: <52B18628.1080607@openwrt.org>
References: <1387340607-20045-1-git-send-email-sujith@msujith.org>
	<1387340607-20045-8-git-send-email-sujith@msujith.org>
	<52B18628.1080607@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> I'm using this function in my work-in-progress patches for p2p
> multichannel.
> Should I switch to using REG_READ in the driver or would you prefer to
> drop this patch instead?

We can drop this patch. I can send it after the p2p work is done.

Jphn, please drop this patch from the series.

Sujith
