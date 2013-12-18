Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:42166 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab3LREQy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 23:16:54 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21169.8334.166813.48938@gargle.gargle.HOWL> (sfid-20131218_051707_910644_5CA495DE)
Date: Wed, 18 Dec 2013 09:41:58 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] ath9k: Fix AR9330 external reset
In-Reply-To: <21169.3973.655226.402799@gargle.gargle.HOWL>
References: <1387303608-31356-1-git-send-email-sujith@msujith.org>
	<1387303608-31356-5-git-send-email-sujith@msujith.org>
	<52B0B7BC.9020307@openwrt.org>
	<21169.3973.655226.402799@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan wrote:
> Maybe this check is unnecessary altogether ? If we are doing a full cold reset,
> the SoC probably needs to be reset as well, so why check for pending frames
> at all ?

For warm reset, this could be required, so we can probably retain the check
for pending TX frames.

Sujith
