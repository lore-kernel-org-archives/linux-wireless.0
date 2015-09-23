Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:40754 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbbIWNOr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 09:14:47 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22018.42528.871404.504088@gargle.gargle.HOWL> (sfid-20150923_151450_818769_331BCC0B)
Date: Wed, 23 Sep 2015 18:46:16 +0530
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k_htc: use ether_addr_copy() instead of memcpy()
In-Reply-To: <1442931866-17115-1-git-send-email-linux@rempel-privat.de>
References: <87lhbylifx.fsf@kamboji.qca.qualcomm.com>
	<1442931866-17115-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oleksij Rempel wrote:
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
> ---
>  drivers/net/wireless/ath/ath9k/htc_drv_init.c |  2 +-
>  drivers/net/wireless/ath/ath9k/htc_drv_main.c | 24 ++++++++++++------------
>  2 files changed, 13 insertions(+), 13 deletions(-)

Both the arguments for ether_addr_copy() need to be
aligned. Is this the case for all the replacements in
this patch ?

Sujith
