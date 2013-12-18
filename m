Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:44958 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab3LRDEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 22:04:14 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21169.3973.655226.402799@gargle.gargle.HOWL> (sfid-20131218_040417_809677_1C042190)
Date: Wed, 18 Dec 2013 08:29:17 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] ath9k: Fix AR9330 external reset
In-Reply-To: <52B0B7BC.9020307@openwrt.org>
References: <1387303608-31356-1-git-send-email-sujith@msujith.org>
	<1387303608-31356-5-git-send-email-sujith@msujith.org>
	<52B0B7BC.9020307@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> In my tests, the external reset helped with getting Tx DMA un-stuck as
> well, even if no beacons are enabled. I think we should keep the tx
> pending check.

Maybe this check is unnecessary altogether ? If we are doing a full cold reset,
the SoC probably needs to be reset as well, so why check for pending frames
at all ?

Sujith

