Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57603 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbaGNNJ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2014 09:09:58 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath6kl@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/6] ath6kl: add ar6004 hw3.0
References: <20140617093836.22040.99081.stgit@potku.adurom.net>
Date: Mon, 14 Jul 2014 16:05:54 +0300
In-Reply-To: <20140617093836.22040.99081.stgit@potku.adurom.net> (Kalle Valo's
	message of "Tue, 17 Jun 2014 12:40:45 +0300")
Message-ID: <87zjgcks3x.fsf@kamboji.qca.qualcomm.com> (sfid-20140714_151001_665999_1FBA5707)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Add support for frequently requested ar6004 hw3.0 version. 
>
> Kalle
>
> ---
>
> Jessica Wu (3):
>       ath6kl: implement rx flush for htc pipe
>       ath6kl: add support wmi rate tables with mcs15
>       ath6kl: add support for ar6004 hw3.0
>
> Kalle Valo (3):
>       ath6kl: convert ar6004 hardware flags to firmware feature flags
>       ath6kl: don't set hi_refclk_hz if hardware version doesn't need
>       it

These patches applied.

>       ath6kl: properly null terminate the firmware string

This patch dropped, I need to fix the warning first.

-- 
Kalle Valo
