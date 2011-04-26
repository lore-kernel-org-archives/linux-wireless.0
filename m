Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38237 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757772Ab1DZUAt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 16:00:49 -0400
Date: Tue, 26 Apr 2011 15:47:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath9k_hw: Fix warnings due to
 -Wunused-but-set-variable
Message-ID: <20110426194741.GL2804@tuxdriver.com> (sfid-20110426_220059_613953_3AB2279E)
References: <1303727180-22212-1-git-send-email-rmanoharan@atheros.com>
 <1303727180-22212-5-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303727180-22212-5-git-send-email-rmanoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 25, 2011 at 03:56:20PM +0530, Rajkumar Manoharan wrote:
> These warnings are exposed by gcc 4.6.
> drivers/net/wireless/ath/ath9k/hw.c: In function
> 'ath9k_hw_fill_cap_info':
> drivers/net/wireless/ath/ath9k/hw.c:1796:6: warning: variable 'capField'
> set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/ath/ath9k/ar9003_phy.c: In function
> 'ar9003_hw_process_ini':
> drivers/net/wireless/ath/ath9k/ar9003_phy.c:602:18: warning: variable
> 'freqIndex' set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/ath/ath9k/eeprom_9287.c: In function
> 'ath9k_hw_set_ar9287_power_cal_table':
> drivers/net/wireless/ath/ath9k/eeprom_9287.c:322:10: warning: variable
> 'modalIdx' set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/ath/ath9k/ar9003_eeprom.c: In function
> 'ar9300_compress_decision':
> drivers/net/wireless/ath/ath9k/ar9003_eeprom.c:3220:6: warning: variable
> 'dptr' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>

This doesn't seem to apply either...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
