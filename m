Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20553 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab1D0EwG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 00:52:06 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 21:51:39 -0700
Date: Wed, 27 Apr 2011 10:22:01 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/5] ath9k_htc: Fix warnings due to
 -Wunused-but-set-variable
Message-ID: <20110427045201.GA16430@vmraj-lnx.users.atheros.com> (sfid-20110427_065209_484410_4272F322)
References: <1303727180-22212-1-git-send-email-rmanoharan@atheros.com>
 <1303727180-22212-4-git-send-email-rmanoharan@atheros.com>
 <20110426194556.GK2804@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20110426194556.GK2804@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 27, 2011 at 01:15:56AM +0530, John W. Linville wrote:
> On Mon, Apr 25, 2011 at 03:56:19PM +0530, Rajkumar Manoharan wrote:
> > These warnings are exposed by gcc 4.6.
> > drivers/net/wireless/ath/ath9k/htc_drv_txrx.c: In function
> > 'ath9k_htc_tx_process':
> > drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:449:35: warning: variable
> > 'sband' set but not used [-Wunused-but-set-variable]
> > drivers/net/wireless/ath/ath9k/htc_drv_beacon.c: In function
> > 'ath9k_htc_beacon_config_sta':
> > drivers/net/wireless/ath/ath9k/htc_drv_main.c: In function
> > 'ath9k_htc_stop':
> > drivers/net/wireless/ath/ath9k/htc_drv_main.c:967:6: warning: variable
> > 'ret' set but not used [-Wunused-but-set-variable]
> > drivers/net/wireless/ath/ath9k/htc_drv_main.c: In function
> > 'ath9k_htc_remove_interface':
> > drivers/net/wireless/ath/ath9k/htc_drv_gpio.c: In function
> > 'ath_btcoex_period_work':
> > drivers/net/wireless/ath/ath9k/htc_drv_gpio.c:67:6: warning: variable
> > 'ret' set but not used [-Wunused-but-set-variable
> >  ...
> > 
> > Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
> 
> This doesn't seem to apply -- what tree are you using?
>
These warnings were already addressed. Please drop this patch
and  "ath9k_hw: Fix warnings due to -Wunused-but-set-variable"
Sorry for the inconvenience.

--
Rajkumar
