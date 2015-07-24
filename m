Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56834 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbbGXHoJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2015 03:44:09 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2] ath10k: Delay device access after cold reset
References: <1436518880-9638-1-git-send-email-vthiagar@qti.qualcomm.com>
Date: Fri, 24 Jul 2015 10:44:02 +0300
In-Reply-To: <1436518880-9638-1-git-send-email-vthiagar@qti.qualcomm.com>
	(Vasanthakumar Thiagarajan's message of "Fri, 10 Jul 2015 14:31:20
	+0530")
Message-ID: <87vbdaf1a5.fsf@kamboji.qca.qualcomm.com> (sfid-20150724_094413_000796_03EFED1D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> writes:

> It is observed that during cold reset pcie access right
> after a write operation to SOC_GLOBAL_RESET_ADDRESS causes
> Data Bus Error and system hard lockup. The reason
> for bus error is that pcie needs some time to get
> back to stable state for any transaction during cold reset. Add
> delay of 20 msecs after write of SOC_GLOBAL_RESET_ADDRESS
> to fix this issue. This patch is tested on QCA988X. This is
> also tested on QCA99X0 which is WIP.
>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
