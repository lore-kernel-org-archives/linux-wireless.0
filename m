Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4675 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758784AbcHaHUD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Aug 2016 03:20:03 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCHv3,
 1/3] ath10k: move firmware_swap_code_seg_info to ath10k_fw_file
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1467356767-31646-1-git-send-email-c_traja@qti.qualcomm.com>
To: <c_traja@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
        Tamizh chelvam <c_traja@qti.qualcomm.com>,
        <tamizhchelvam@codeaurora.org>, <linux-wireless@vger.kernel.org>
Message-ID: <4b5f565d8e124aca9debc00ee47efb2e@euamsexm01a.eu.qualcomm.com> (sfid-20160831_092029_393850_953660F5)
Date: Wed, 31 Aug 2016 09:19:31 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

c_traja@qti.qualcomm.com wrote:
> From: Tamizh chelvam <c_traja@qti.qualcomm.com>
> 
> Preparation to make use of firmware_swap_code_seg_info for UTF binary.
> 
> Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>

Thanks, 3 patches applied to ath-next branch of ath.git:

5459c5d47608 ath10k: move firmware_swap_code_seg_info to ath10k_fw_file
d912fc094bc4 ath10k: handle testmode events for 10.2 and 10.4 based firmware
ebce1a5e3a0e ath10k: add testmode support for 10.4 firmware

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9209331/
