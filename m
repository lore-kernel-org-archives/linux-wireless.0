Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:39977 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaBZLKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 06:10:16 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21261.52075.233979.642924@gargle.gargle.HOWL> (sfid-20140226_121021_042993_1E395BF0)
Date: Wed, 26 Feb 2014 16:39:31 +0530
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH 0/7] ath9k|ath9k_htc: remove code dups
In-Reply-To: <1393336136-31069-1-git-send-email-linux@rempel-privat.de>
References: <1393336136-31069-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oleksij Rempel wrote:
> ath9k code moved to common-init.c and then reused in ath9k_htc.
> 
> Oleksij Rempel (7):
>   ath9k: move ath9k_init_channels_rates to common-init
>   ath9k_htc: use ath9k_cmn_init_channels_rates
>   ath9k: move setup_ht_cap to common-init
>   ath9k_htc: use ath9k_cmn_setup_ht_cap
>   ath9k-common: set maxstream=1 for ar9271
>   ath9k: move ath9k_reload_chainmask_settings to common
>   ath9k_htc: use ath9k_cmn_reload_chainmask

This series looks good.

Sujith
