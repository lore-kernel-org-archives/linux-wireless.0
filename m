Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24834 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbbJSOmz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 10:42:55 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <c_traja@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2 v2] ath10k: print firwmare stats specific to firmware version
References: <1444812751-11103-1-git-send-email-c_traja@qti.qualcomm.com>
Date: Mon, 19 Oct 2015 17:42:40 +0300
In-Reply-To: <1444812751-11103-1-git-send-email-c_traja@qti.qualcomm.com> (c.
	traja's message of "Wed, 14 Oct 2015 14:22:31 +0530")
Message-ID: <87vba2gbrz.fsf@kamboji.qca.qualcomm.com> (sfid-20151019_164259_231174_67E624AF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<c_traja@qti.qualcomm.com> writes:

> From: Tamizh chelvam <c_traja@qti.qualcomm.com>
>
> Currently printing fw stats in ath10k is common to all firmware versions.
> Printing all the stats might lead to confusion because some of the stats
> are firmware specific and when printed will have 0's.
> Below patchset prints firmware stats specific to firmware.
>
> v2:
>         > All the filtered functions moved to wmi.c
>         > Added firmware stats support for 10.4 firmware.
>
> Manikanta (2):
>   ath10k: Make fw stats prints specific to firmware version

Applied this patch.

>   ath10k: add fw_stats support to 10.4 firmware

Dropped this patch due to the bug I saw. Please resend once you have
fixed that.

-- 
Kalle Valo
