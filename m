Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54911 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758396Ab1DYK55 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 06:57:57 -0400
Received: by pvg12 with SMTP id 12so1145573pvg.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Apr 2011 03:57:57 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19893.21584.569149.22313@gargle.gargle.HOWL> (sfid-20110425_125801_223358_DBAB3314)
Date: Mon, 25 Apr 2011 16:30:32 +0530
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/5] ath9k: Fix warnings due to -Wunused-but-set-variable
In-Reply-To: <1303727180-22212-3-git-send-email-rmanoharan@atheros.com>
References: <1303727180-22212-1-git-send-email-rmanoharan@atheros.com>
	<1303727180-22212-3-git-send-email-rmanoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> These warnings are exposed by gcc 4.6.
> drivers/net/wireless/ath/ath9k/recv.c: In function 'ath_ant_comb_scan':
> drivers/net/wireless/ath/ath9k/recv.c:1342:21: warning: variable
> 'curr_bias' set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/ath/ath9k/rc.c: In function 'ath_rc_update_ht':
> drivers/net/wireless/ath/ath9k/rc.c:1020:7: warning: variable
> 'state_change' set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/ath/ath9k/ani.c: In function 'ath9k_hw_ani_init':
> drivers/net/wireless/ath/ath9k/ani.c:903:37: warning: variable
> 'entry_cck' set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/ath/ath9k/ani.c:902:38: warning: variable
> 'entry_ofdm' set but not used [-Wunused-but-set-variable]
> 

http://marc.info/?l=linux-wireless&m=130327729324100&w=2

Sujith
