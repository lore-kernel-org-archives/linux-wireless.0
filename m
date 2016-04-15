Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58554 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbcDOShb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2016 14:37:31 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [01/26] rtl8xxxu: Reorder parts of init code to match the
 8192euvendor code flow
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1460660347-26299-2-git-send-email-Jes.Sorensen@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Message-Id: <20160415183730.740806075C@smtp.codeaurora.org> (sfid-20160415_203734_500806_7D44914C)
Date: Fri, 15 Apr 2016 18:37:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> In order to debug 8192eu support, reorder some init code to match the
> flow of the vendor driver.
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Thanks, 26 patches applied to wireless-drivers-next.git:

c157863d9979 rtl8xxxu: Reorder parts of init code to match the 8192eu vendor code flow
59b24dad20d4 rtl8xxxu: Reorg more code to match the flow of the 8192eu vendor driver
89c2a097df34 rtl8xxxu: Implement generic init_queue_reserved_page() function
0486e80b2a44 rtl8xxxu: Reorder chip quirks to follow flow of 8192eu driver
2e7c7b347d93 rtl8xxxu: Do not set REG_PBP on 8192eu
b816901b3d20 rtl8xxxu: Do not init FPGA0_TX_INFO on 8192eu
5bdb6b085988 rtl8xxxu: Do not try to set REG_LEDCFG2 on 8192eu
57e42a21a941 rtl8xxxu: Implment rtl8192e_set_tx_power()
55c0b6ae1e7b rtl8xxxu: Use has_s0s1 for REG_S0S1 issues only
2cb79eb74f08 rtl8xxxu: byteswap the entire RX descriptor for 24 byte RX descriptors
a49c7ce183cd rtl8xxxu: Name RX descriptor types rxdesc16/rxdesc24
fe62171fb5ca rtl8xxxu: Remove misleading warning from rtl8192eu_phy_iqcalibrate()
15f9dc99237d rtl8xxxu: Remove unused 8723bu path B IQ calibration code
9068308ad185 rtl8xxxu: Correctly mask what was read from REG_CCK0_AFE_SETTING
bd8fe40cc4f3 rtl8xxxu: Use descriptive bits for setting RX paths for 1T2R parts
cb8772504a27 rtl8xxxu: Split rtl8xxxu_init_phy_bb() into device specific functions
ade0dedde119 rtl8xxxu: Load AGC table before patching for 1T2R parts
c82f8d113e35 rtl8xxxu: Move loading of AGC table to device specific function
b84cac16f0f4 rtl8xxxu: REG_LDOA15_CTRL is only used on gen1 parts
24e8e7ec331d rtl8xxxu: Store device specific TRXFF boundary in the fileops
a77372069119 rtl8xxxu: Do not backup RF_MODE_AG when it's never being used
9b323ee97af6 rtl8xxxu: Make PBP tuning a fileops parameter
747bf237592c rtl8xxxu: Split USB quirks into gen1 and gen2 quirks
31133da702e4 rtl8xxxu: Remove unneeded 8192eu hack
46b378318de9 rtl8xxxu: 8192eu Fix bug in LDPC RX hang fix
a39b68396655 Re-enable 8192eu support

Kalle Valo
