Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:33373 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758997Ab3EOP4m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 11:56:42 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20883.44965.174742.469466@gargle.gargle.HOWL> (sfid-20130515_175646_164027_D5765D74)
Date: Wed, 15 May 2013 21:24:13 +0530
To: Joe Perches <joe@perches.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <ath10k-devel@qca.qualcomm.com>
Subject: Re: [PATCH 00/29] ath10k: mac80211 driver for Qualcomm Atheros
 qca988x devices
In-Reply-To: <1368633142.2194.6.camel@joe-AO722>
References: <20130515143356.4492.43033.stgit@localhost6.localdomain6>
	<1368633142.2194.6.camel@joe-AO722>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches wrote:
> Perhaps it would be reasonable to create and use standardized
> logging ath_<level> functions for all the device ath<x>k_<level>s.

Indeed.

You already did that in "ath: Add and use ath_printk and ath_<level>" :)

Sujith
