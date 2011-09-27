Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52371 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab1I0HRY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 03:17:24 -0400
Message-ID: <4E81787D.1010004@qca.qualcomm.com> (sfid-20110927_091727_939345_14238DBB)
Date: Tue, 27 Sep 2011 10:17:17 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Fix compilation error while compiling w/o debug
References: <1317027558-2691-1-git-send-email-rmanohar@qca.qualcomm.com>
In-Reply-To: <1317027558-2691-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/26/2011 11:59 AM, Rajkumar Manoharan wrote:
> drivers/net/wireless/ath/ath6kl/htc_hif.o:
> In function `ath6kl_debug_fwlog_event':
> drivers/net/wireless/ath/ath6kl/debug.h:109:
> multiple definition of `ath6kl_debug_fwlog_event'
> drivers/net/wireless/ath/ath6kl/debug.o:
> drivers/net/wireless/ath/ath6kl/debug.h:109: first defined here
> drivers/net/wireless/ath/ath6kl/htc_hif.o:
> In function `ath6kl_debug_cleanup':
> drivers/net/wireless/ath/ath6kl/debug.h:118:
> multiple definition of `ath6kl_debug_cleanup'
> drivers/net/wireless/ath/ath6kl/debug.o:
> drivers/net/wireless/ath/ath6kl/debug.h:118: first defined here

I broke this, thank you for fixing it. Patch applied.

Kalle
