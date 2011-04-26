Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38239 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757782Ab1DZUAt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 16:00:49 -0400
Date: Tue, 26 Apr 2011 15:45:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/5] ath9k_htc: Fix warnings due to
 -Wunused-but-set-variable
Message-ID: <20110426194556.GK2804@tuxdriver.com> (sfid-20110426_220100_176882_8D861787)
References: <1303727180-22212-1-git-send-email-rmanoharan@atheros.com>
 <1303727180-22212-4-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303727180-22212-4-git-send-email-rmanoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 25, 2011 at 03:56:19PM +0530, Rajkumar Manoharan wrote:
> These warnings are exposed by gcc 4.6.
> drivers/net/wireless/ath/ath9k/htc_drv_txrx.c: In function
> 'ath9k_htc_tx_process':
> drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:449:35: warning: variable
> 'sband' set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/ath/ath9k/htc_drv_beacon.c: In function
> 'ath9k_htc_beacon_config_sta':
> drivers/net/wireless/ath/ath9k/htc_drv_main.c: In function
> 'ath9k_htc_stop':
> drivers/net/wireless/ath/ath9k/htc_drv_main.c:967:6: warning: variable
> 'ret' set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/ath/ath9k/htc_drv_main.c: In function
> 'ath9k_htc_remove_interface':
> drivers/net/wireless/ath/ath9k/htc_drv_gpio.c: In function
> 'ath_btcoex_period_work':
> drivers/net/wireless/ath/ath9k/htc_drv_gpio.c:67:6: warning: variable
> 'ret' set but not used [-Wunused-but-set-variable
>  ...
> 
> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>

This doesn't seem to apply -- what tree are you using?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
