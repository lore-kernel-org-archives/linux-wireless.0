Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:34248 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbaI3BUH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 21:20:07 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21546.1381.6346.449656@gargle.gargle.HOWL> (sfid-20140930_032011_698217_733CF283)
Date: Tue, 30 Sep 2014 06:50:37 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 1/3] Revert "ath9k_hw: reduce ANI firstep range for older chips"
In-Reply-To: <1412016342-21227-1-git-send-email-nbd@openwrt.org>
References: <1412016342-21227-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> This reverts commit 09efc56345be4146ab9fc87a55c837ed5d6ea1ab
> 
> I've received reports that this change is decreasing throughput in some
> rare conditions on an AR9280 based device

Wasn't the original patch for improving stability ? Won't reverting it
reintroduce the earlier situation ?

If ANI issues/regressions for pre-AR9003 chips are still arising,
I wonder what we have gained by the switch and if the new algorithm
is a good fit for the older chips.

At least for SoC chips, people will report it to OpenWrt. For PC-OEM
cards, users will just say that the card sucks and move on...

Sujith
