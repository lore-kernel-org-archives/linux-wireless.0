Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:42103 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbbCNFxA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 01:53:00 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21763.52634.660667.367855@gargle.gargle.HOWL> (sfid-20150314_065313_073527_FC744A1A)
Date: Sat, 14 Mar 2015 11:26:42 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/5] ath9k patches
In-Reply-To: <5503BA87.7000309@openwrt.org>
References: <1425891010-21522-1-git-send-email-sujith@msujith.org>
	<87wq2lqb1d.fsf@kamboji.qca.qualcomm.com>
	<21763.32496.935954.70693@gargle.gargle.HOWL>
	<5503BA87.7000309@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> It's probably enough to just change struct ath_aic_sram_info to make it
> fit: Just put the bool fields together and make them single-bit.
> This should save more than 300 bytes.

Yes, that works too. Thanks.

Sujith
