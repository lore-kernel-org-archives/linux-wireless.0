Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60898 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbcF3MnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 08:43:22 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Raja, Tamizh Chelvam" <c_traja@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHV2 1/3] ath10k: move firmware_swap_code_seg_info to
 ath10k_fw_file
Date: Thu, 30 Jun 2016 12:40:16 +0000
Message-ID: <8760sq6ea9.fsf@kamboji.qca.qualcomm.com> (sfid-20160630_144328_934406_50D246D5)
References: <1467018404-24460-1-git-send-email-c_traja@qti.qualcomm.com>
In-Reply-To: <1467018404-24460-1-git-send-email-c_traja@qti.qualcomm.com> (c.
	traja's message of "Mon, 27 Jun 2016 14:36:44 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<c_traja@qti.qualcomm.com> writes:

> From: Tamizh chelvam <c_traja@qti.qualcomm.com>
>
> Preparation to make use of firmware_swap_code_seg_info for
> UTF binary.
>
> Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>

This patchset crashes my x86 laptop once I start hostapd. Unfortunately
I can't provide any logs as I don't have netconsole set up yet, but this
is the board I'm using:

[   58.481559] ath10k_pci 0000:02:00.0: pci irq msi oper_irq_mode 2 irq_mode 0 reset_mode 0
[   58.633122] ath10k_pci 0000:02:00.0: qca988x hw2.0 target 0x4100016c chip_id 0x043202ff sub 0000:0000
[   58.633126] ath10k_pci 0000:02:00.0: kconfig debug 1 debugfs 1 tracing 1 dfs 0 testmode 1
[   58.633318] ath10k_pci 0000:02:00.0: firmware ver 10.2.4.70.52 api 5 features no-p2p,raw-mode,mfp crc32 67c4d25c
[   58.690098] ath10k_pci 0000:02:00.0: board_file api 1 bmi_id N/A crc32 bebc7c08
[   59.950554] ath10k_pci 0000:02:00.0: htt-ver 2.1 wmi-op 5 htt-op 2 cal otp max-sta 128 raw 0 hwcrypto 1

-- 
Kalle Valo