Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56895 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760104AbcBYJ5K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2016 04:57:10 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [01/28] rtl8xxxu: Minor cleanup to rtl8xxxu_download_firmware()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1454524802-26763-2-git-send-email-Jes.Sorensen@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Message-Id: <20160225095710.2FCD1603D8@smtp.codeaurora.org> (sfid-20160225_105738_634724_49DD30F4)
Date: Thu, 25 Feb 2016 09:57:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Thanks, 28 patches applied to wireless-drivers-next.git:

43154f6fd46b rtl8xxxu: Minor cleanup to rtl8xxxu_download_firmware()
ef1c0499316b rtl8xxxu: rtl8xxxu_download_firmware(): Cosmetic cleanups
216202ae20ea rtl8xxxu: If fw running in RAM, reset the 8051 before trying to download a new one
0635f8cede15 rtl8xxxu: Add RQPN_[NE]PQ_SHIFT values
f076977537d9 rtl8xxxu: Define SYS_CFG_SW_OFFLOAD_EN
cecfd3cb29f8 rtl8xxxu: Add REG_TX_REPORT_* defines
22229fcb487a rtl8xxxu: Add more RCR bits
c1edece3c22b rtl8xxxu: Fix typo in Kconfig help text
98e27cbd9453 rtl8xxxu: Check return value of kmemdup()
d48fe60e06f4 rtl8xxxu: Implement rtl8xxxu_reset_8051()
af9e4d6d9d07 rtl8xxxu: Add definitions for antenna selection registers for 8723BU
29c2139cd04a rtl8xxxu: Add mbox extension register definitions for 8723B
ce6f2e366954 rtl8xxxu: Add REG_OFDM0_RX_D_SYNC_PATH definitions
e5c447ccf8e5 rtl8xxxu: Remove unused clutter for handling recursive calls to rtl8xxxu_init_device()
38451998fb8a rtl8xxxu: Use REG_EFUSE_TEST register only on multifunctional devices
56e4374a5e08 rtl8xxxu: Fix cosmetics to quiet down checkpatch police
3bed4bfa51f2 rtl8xxxu: Enable monitor mode by handling filters
b40027ba8db1 rtl8xxxu: Document REG_RXFLTMAP registers
124bc63c995d rtl8xxxu: Remove duplicate USB ID
755bda116e8a rtl8xxxu: Fix 80 character per line issue
c85ea1156d78 rtl8xxxu: Enable data frame reception in rtl8xxxu_start
a26703f39d2f rtl8xxxu: rtl8xxxu_set_linktype(): Be consistent aboutregister size REG_MSR
53b381c4d72a rtl8xxxu: Set correct bit to reset MCU IO wrapper
796c554257b1 rtl8xxxu: Remove unused mgmt variable from rtl8xxxu_rx_complete()
a9ffa615aa4c rtl8xxxu: Remove unused len/cnt variables from rtl8xxxu_rx_complete()
dc254ca41134 rtl8xxxu: Do not mask RF registers to 6 bits
4042e61735ce rtl8xxxu: Make device_init kludge 8723au only
5b22a111aa15 rtl8xxxu: Add missing bit define for REG_APS_FSMCO

Kalle Valo
