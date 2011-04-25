Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63700 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495Ab1DYMVX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 08:21:23 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 25 Apr 2011 05:20:56 -0700
Date: Mon, 25 Apr 2011 17:51:20 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Sujith <m.sujith@gmail.com>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/5] ath9k: Fix warnings due to -Wunused-but-set-variable
Message-ID: <20110425122120.GA27808@vmraj-lnx.users.atheros.com> (sfid-20110425_142126_218325_C617E3E1)
References: <1303727180-22212-1-git-send-email-rmanoharan@atheros.com>
 <1303727180-22212-3-git-send-email-rmanoharan@atheros.com>
 <19893.21584.569149.22313@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <19893.21584.569149.22313@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 25, 2011 at 04:30:32PM +0530, Sujith wrote:
> Rajkumar Manoharan wrote:
> > These warnings are exposed by gcc 4.6.
> > drivers/net/wireless/ath/ath9k/recv.c: In function 'ath_ant_comb_scan':
> > drivers/net/wireless/ath/ath9k/recv.c:1342:21: warning: variable
> > 'curr_bias' set but not used [-Wunused-but-set-variable]
> > drivers/net/wireless/ath/ath9k/rc.c: In function 'ath_rc_update_ht':
> > drivers/net/wireless/ath/ath9k/rc.c:1020:7: warning: variable
> > 'state_change' set but not used [-Wunused-but-set-variable]
> > drivers/net/wireless/ath/ath9k/ani.c: In function 'ath9k_hw_ani_init':
> > drivers/net/wireless/ath/ath9k/ani.c:903:37: warning: variable
> > 'entry_cck' set but not used [-Wunused-but-set-variable]
> > drivers/net/wireless/ath/ath9k/ani.c:902:38: warning: variable
> > 'entry_ofdm' set but not used [-Wunused-but-set-variable]
> > 
> 
> http://marc.info/?l=linux-wireless&m=130327729324100&w=2
>
John,

Warnings in ath9k were already address by Sujith.
Please drop ath9k related warning patches.

--
Rajkumar
