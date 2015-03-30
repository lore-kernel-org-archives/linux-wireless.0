Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57799 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbbC3Ica (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:32:30 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v3,01/18] ath9k_htc: add new WMI_REG_RMW_CMDID command
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1427049003-8443-2-git-send-email-linux@rempel-privat.de>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Oleksij Rempel <linux@rempel-privat.de>
Message-Id: <20150330083229.A29981401F7@smtp.codeaurora.org> (sfid-20150330_103234_501538_02175664)
Date: Mon, 30 Mar 2015 08:32:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Since usb bus add extra delay on each request, a command
> with read + write requests is too expensive. We can dramtically
> reduce usb load by moving this command to firmware.
> 
> In my tests, this patch will reduce channel scan time
> for about 5-10 seconds.
> 
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>

Thanks, 18 patches applied to wireless-drivers-next.git:

8badb50cfab6 ath9k_htc: add new WMI_REG_RMW_CMDID command
8d1cbdef8a64 ath9k: ar9271_hw_pa_cal - use defs instead of magin numbers
0202a553f59b ath9k: ar9271_hw_pa_cal: use proper makroses.
93442c85d23a ath9k: ar9271_hw_pa_cal: use RMW buffer
d55ce0a6f983 ath9k: add multi_read to be compatible with ath9k_htc
a57cb45a0a05 ath9k: add new function ath9k_hw_read_array
03822782e829 ath9k: ar9271_hw_pa_cal: use REG_READ_ARRAY
9c05babd933e ath9k: use one shot read in ath9k_hw_update_mibstats
9830ba6c9ad0 ath9k: ath9k_hw_loadnf: use REG_RMW
3df5dd901d1a ath9k: write buffer related optimisation in ar5008_hw_set_channel_regs
10e03ef6b466 ath9k: ath9k_hw_set_4k_power_cal_tabl: use rmw buffer
7b37e0d4db03 ath9k: use rmw buffer in ath9k_hw_set_operating_mode and ath9k_hw_reset
18d6616f1bb1 ath9k: ath9k_hw_4k_set_board_values: use rmw buffer
2028523b6dce ath9k: ath9k_hw_analog_shift_rmw: use REG_RMW
ad10e0d65030 ath9k: ath9k_hw_4k_set_board_values: use rmw buffer
2dfc0247f0ff ath9k: use REG_RMW and rmw buffer in ath9k_hw_4k_set_gain
b1c1a26461a7 ath9k: use REG_RMW and rmw buffer in ath9k_hw_4k_set_board_values
eaa4059d56fd ath9k: use REG_RMW and rmw buffer in ath9k_hw_def_set_gain

Kalle Valo
