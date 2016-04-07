Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51870 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbcDGQi4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 12:38:56 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [01/19] ath9k: Remove unnecessary ?: operator
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <61d140e53a590054c5981788ed12fdda9ef4c0bb.1458262312.git.julian.calaby@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Ivan Safonov <insafonov@gmail.com>,
	Miaoqing Pan <miaoqing@codeaurora.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Message-Id: <20160407163855.DC43A611CD@smtp.codeaurora.org> (sfid-20160407_183859_533870_D2612D74)
Date: Thu,  7 Apr 2016 16:38:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Ivan Safonov <insafonov@gmail.com>
> 
> "(thermometer < 0) ? 0 : (thermometer == X)" is equivalent to
> "thermometer == X" for X >= 0.
> 
> Signed-off-by: Ivan Safonov <insafonov@gmail.com>
> [Updated commit message]
> Signed-off-by: Julian Calaby <julian.calaby@gmail.com>

Thanks, 16 patches applied to wireless-drivers-next.git:

0fef3c768037 ath9k: Remove unnecessary ?: operator
ea544aab42db ipw2x00: use to_pci_dev()
61383412f00d wlcore: use to_delayed_work()
d1162f0283f0 wl1251: use to_delayed_work()
4679f4132201 rtlwifi: use to_delayed_work()
cfbfbd13695c ath9k_htc: Delete unnecessary variable initialisation
9e12904a953c brcmfmac: Delete unnecessary variable initialisation
fb9693f04544 iwlegacy: Return directly if allocation fails in il_eeprom_init()
fe9b47944edf iwl4965: Fix a null pointer dereference in il_tx_queue_free and il_cmd_queue_free
96838d61102a b43: Fix memory leaks in b43_bus_dev_ssb_init and b43_bus_dev_bcma_init
1c76b4902c26 rtl818x_pci: Disable pci device in error handling code
8b28310efe24 rsi: Delete unnecessary variable initialisation
ab2ef1d68f62 rsi: Delete unnecessary variable initialisation
37190b269491 rsi: Move variable initialisation into error code
c2fd34469d16 iwl4965: Fix a memory leak in error handling code of __il4965_up
84d17a2a5a0f iwl4965: Fix more memory leaks in __il4965_up()

Kalle Valo
