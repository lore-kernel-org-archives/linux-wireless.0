Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:61864 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbbHFHoL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 03:44:11 -0400
Message-ID: <55C31039.6030201@qti.qualcomm.com> (sfid-20150806_094415_049219_2FD5699A)
Date: Thu, 6 Aug 2015 13:13:53 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>, <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Subject: Re: [PATCH] ath10k: Add QCA99X0 to supported device list
References: <1437478567-11339-1-git-send-email-vthiagar@qti.qualcomm.com> <55C1FFBC.7070905@openwrt.org>
In-Reply-To: <55C1FFBC.7070905@openwrt.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 05 August 2015 05:51 PM, Felix Fietkau wrote:
> On 2015-07-21 13:36, Vasanthakumar Thiagarajan wrote:
>> Add vendor/device id of QCA99X0 V2.0 to pci id table and
>> QCA99X0_HW_2_0_CHIP_ID_REV to ath10k_pci_supp_chips[] for
>> QCA99X0 to get detected by the driver.
>>
>> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
> I just tested a 99X0 card, and I'm getting this:
>
> [    8.742514] ath10k_pci 0000:01:00.0: enabling device (0140 -> 0142)
> [    8.747173] ath10k_pci 0000:01:00.0: pci irq msi interrupts 1 irq_mode 0 reset_mode 0
> [   11.793314] ath10k_pci 0000:01:00.0: failed to receive initialized event from target: 00000000
> [   11.793344] ath10k_pci 0000:01:00.0: failed to wait for target after cold reset: -110
> [   11.800814] ath10k_pci 0000:01:00.0: failed to reset chip: -110
> [   11.809228] ath10k_pci: probe of 0000:01:00.0 failed with error -110
>
> This is on an AP148 board with Linux 3.18, backports generated from
> latest wireless-testing (2015-08-03) + all patches from kvalo's ath
> tree.

Any idea about the version of AP148 that you are using?. By any chance did
you check if QCA988X is working on the same board?.

Vasanth

