Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:48658 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaI3Ik0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 04:40:26 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21546.27787.196092.518463@gargle.gargle.HOWL> (sfid-20140930_104037_949004_1137C83D)
Date: Tue, 30 Sep 2014 14:10:43 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 1/3] Revert "ath9k_hw: reduce ANI firstep range for older
 chips"
In-Reply-To: <542A6A2A.4070506@openwrt.org>
References: <1412016342-21227-1-git-send-email-nbd@openwrt.org>
	<21546.1381.6346.449656@gargle.gargle.HOWL>
	<542A6A2A.4070506@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> For pre-AR9003, most devices used with OpenWrt actually use exactly the
> same chips as PC-OEM cards.

Yes, that is true. We split the SoC/PC-OEM chip lines in AR9003.
Sorry for the noise. ;)

Sujith
