Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16490 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbbG3OEy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 10:04:54 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Add QCA99X0 to supported device list
References: <1437478567-11339-1-git-send-email-vthiagar@qti.qualcomm.com>
Date: Thu, 30 Jul 2015 17:04:43 +0300
In-Reply-To: <1437478567-11339-1-git-send-email-vthiagar@qti.qualcomm.com>
	(Vasanthakumar Thiagarajan's message of "Tue, 21 Jul 2015 17:06:07
	+0530")
Message-ID: <87vbd13fno.fsf@kamboji.qca.qualcomm.com> (sfid-20150730_160457_454321_563A52C7)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> writes:

> Add vendor/device id of QCA99X0 V2.0 to pci id table and
> QCA99X0_HW_2_0_CHIP_ID_REV to ath10k_pci_supp_chips[] for
> QCA99X0 to get detected by the driver.
>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>

Thanks, applied. I just modified the commit log to make it a bit clear
that QCA99X0 is now working:

    ath10k: add QCA99X0 to supported device list
    
    Add vendor/device id of QCA99X0 V2.0 to pci id table and
    QCA99X0_HW_2_0_CHIP_ID_REV to ath10k_pci_supp_chips[] for
    QCA99X0 to get detected by the driver.
    
    kvalo: now QCA99X0 family of chipsets is supported by ath10k. Tested
    client, AP and monitor mode with QCA9990.
    
    Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

-- 
Kalle Valo
