Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:35144 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbaKLX7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 18:59:18 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21603.62634.825155.906281@gargle.gargle.HOWL> (sfid-20141113_005926_083044_424691A5)
Date: Thu, 13 Nov 2014 05:30:42 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: "Pan\, Miaoqing" <miaoqing@qti.qualcomm.com>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH 4/6] ath9k: Fix high tx power in multi-chain mode
In-Reply-To: <54631EC7.1030009@openwrt.org>
References: <1415689644-29693-1-git-send-email-sujith@msujith.org>
	<1415689644-29693-5-git-send-email-sujith@msujith.org>
	<54621BFF.7080709@openwrt.org>
	<21602.40415.179942.572517@gargle.gargle.HOWL>
	<5326b4c51c744de285b390d8c78a47be@NASANEXM01E.na.qualcomm.com>
	<21602.54599.303861.990586@gargle.gargle.HOWL>
	<54631EC7.1030009@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> Makes sense. I don't like all these duplicated SREV checks though.
> Let's store the chip_chainmask variable from ath9k_hw_fill_cap_info
> somewhere in ath_hw and use that.

I'll send a v2.

Sujith
