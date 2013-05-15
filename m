Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:45056 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758111Ab3EOPwX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 11:52:23 -0400
Message-ID: <1368633142.2194.6.camel@joe-AO722> (sfid-20130515_175226_498612_1A7C08F4)
Subject: Re: [PATCH 00/29] ath10k: mac80211 driver for Qualcomm Atheros
 qca988x devices
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k-devel@qca.qualcomm.com
Date: Wed, 15 May 2013 08:52:22 -0700
In-Reply-To: <20130515143356.4492.43033.stgit@localhost6.localdomain6>
References: <20130515143356.4492.43033.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-05-15 at 17:42 +0300, Kalle Valo wrote:
> Here's a new mac80211 driver for Qualcomm Atheros qca988x devices.
> A major difference from ath9k is that there's now a firmware and
> that's why we had to implement a new driver.
[]
>       ath10k: add debug.c
>       ath10k: add debug.h

Perhaps it would be reasonable to create and use standardized
logging ath_<level> functions for all the device ath<x>k_<level>s.


