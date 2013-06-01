Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:37771 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab3FAMJv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jun 2013 08:09:51 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Raja Mani <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: Check wmi ready event status before validating abi version
References: <1363666715-10854-1-git-send-email-rmani@qca.qualcomm.com>
Date: Sat, 1 Jun 2013 15:09:45 +0300
In-Reply-To: <1363666715-10854-1-git-send-email-rmani@qca.qualcomm.com> (Raja
	Mani's message of "Tue, 19 Mar 2013 09:48:35 +0530")
Message-ID: <87sj12niba.fsf@kamboji.qca.qualcomm.com> (sfid-20130601_140954_458876_00F69CBE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Raja Mani <rmani@qca.qualcomm.com> writes:

> There is no point to check firmware ABI version when the driver
> fails to wait for WMI_READY event during the boot time.
>
> For such failures, the driver should assume the firmware is not
> booted and start doing cleanup.
>
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
