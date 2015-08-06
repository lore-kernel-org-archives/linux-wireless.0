Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49636 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679AbbHFSpp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 14:45:45 -0400
Message-ID: <55C3AB2F.9030904@codeaurora.org> (sfid-20150806_204548_542749_F7FFE2B1)
Date: Thu, 06 Aug 2015 11:45:03 -0700
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>,
	ath10k@lists.infradead.org
CC: Kalle Valo <kvalo@qca.qualcomm.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Add QCA99X0 to supported device list
References: <1437478567-11339-1-git-send-email-vthiagar@qti.qualcomm.com> <55C1FFBC.7070905@openwrt.org> <55C31039.6030201@qti.qualcomm.com> <55C313D3.4080004@openwrt.org>
In-Reply-To: <55C313D3.4080004@openwrt.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 08/06/2015 12:59 AM, Felix Fietkau wrote:
> On 2015-08-06 09:43, Vasanthakumar Thiagarajan wrote:
>> On Wednesday 05 August 2015 05:51 PM, Felix Fietkau wrote:
>>> On 2015-07-21 13:36, Vasanthakumar Thiagarajan wrote:
>>>> Add vendor/device id of QCA99X0 V2.0 to pci id table and
>>>> QCA99X0_HW_2_0_CHIP_ID_REV to ath10k_pci_supp_chips[] for
>>>> QCA99X0 to get detected by the driver.
>>>>
>>>> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
>>> I just tested a 99X0 card, and I'm getting this:
>>>
>>> [    8.742514] ath10k_pci 0000:01:00.0: enabling device (0140 -> 0142)
>>> [    8.747173] ath10k_pci 0000:01:00.0: pci irq msi interrupts 1
> irq_mode 0 reset_mode 0
>>> [   11.793314] ath10k_pci 0000:01:00.0: failed to receive initialized
> event from target: 00000000
>>> [   11.793344] ath10k_pci 0000:01:00.0: failed to wait for target after
> cold reset: -110
>>> [   11.800814] ath10k_pci 0000:01:00.0: failed to reset chip: -110
>>> [   11.809228] ath10k_pci: probe of 0000:01:00.0 failed with error -110
>>>
>>> This is on an AP148 board with Linux 3.18, backports generated from
>>> latest wireless-testing (2015-08-03) + all patches from kvalo's ath
>>> tree.
>> Any idea about the version of AP148 that you are using?. By any chance
> did
>> you check if QCA988X is working on the same board?.
> No idea about the version, but QCA988X is working in the same slot.
QCA99X0 uses a different version of firmware from QCA988X.
Could you verify which firmware version or file name is using?
> - Felix
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
Thanks,
Peter
