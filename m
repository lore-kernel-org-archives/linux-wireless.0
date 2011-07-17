Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31891 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab1GQGKx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 02:10:53 -0400
Date: Sun, 17 Jul 2011 11:40:58 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath9k: Fix sparse warnings
Message-ID: <20110717061056.GA9785@vmraj-lnx.users.atheros.com> (sfid-20110717_081057_645765_870A4006)
References: <1310882929-10528-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1310882929-10528-1-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 17, 2011 at 11:38:48AM +0530, Rajkumar Manoharan wrote:
> drivers/net/wireless/ath/ath9k/init.c:199:21: warning: context imbalance
> in 'ath9k_reg_rmw' - different lock contexts for basic block
> drivers/net/wireless/ath/ath9k/xmit.c:1175:31: warning: context
> imbalance in 'ath_drain_txq_list' - unexpected unlock
> drivers/net/wireless/ath/ath9k/xmit.c:2047:23: warning: context
> imbalance in 'ath_tx_process_buffer' - unexpected unlock
> drivers/net/wireless/ath/ath9k/ar9003_eeprom.c:3041:24: warning: cast to
> restricted __le32
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
John,

I missed a checkpatch warning. Will send v2 patch. Sorry for the inconvenience

--
Rajkumar
