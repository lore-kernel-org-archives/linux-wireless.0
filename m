Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:59502
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964983Ab2LGCpO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 21:45:14 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20673.22551.238357.62260@gargle.gargle.HOWL> (sfid-20121207_034526_454940_C6DE90D9)
Date: Fri, 7 Dec 2012 08:14:39 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, rmanohar@qca.qualcomm.com
Subject: Re: [PATCH] Revert "ath9k_hw: Update AR9003 high_power tx gain table"
In-Reply-To: <1354815611-7220-1-git-send-email-nbd@openwrt.org>
References: <1354815611-7220-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> This reverts commit f74b9d365ddd33a375802b064f96a5d0e99af7c0.
> 
> Turns out reverting commit a240dc7b3c7463bd60cf0a9b2a90f52f78aae0fd
> "ath9k_hw: Updated AR9003 tx gain table for 5GHz" was not enough to
> bring the tx power back to normal levels on devices like the
> Buffalo WZR-HP-G450H, this one needs to be reverted as well.
> 
> This revert improves tx power by ~10 db on that device

Will this impact other devices ?

Sujith
