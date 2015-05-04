Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51998 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbbEDRz3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 13:55:29 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add ATH10K_FW_FEATURE_IGNORE_OTP_RESULT
References: <20150427142438.25600.26537.stgit@potku.adurom.net>
Date: Mon, 4 May 2015 20:55:01 +0300
In-Reply-To: <20150427142438.25600.26537.stgit@potku.adurom.net> (Kalle Valo's
	message of "Mon, 27 Apr 2015 17:24:38 +0300")
Message-ID: <874mnsw7m2.fsf@kamboji.qca.qualcomm.com> (sfid-20150504_195533_330633_074B74BB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> qca6174 otp binary seems to always return an error to the host, even if the
> calibration succeeded. Add a firmware feature flag to detect if the firmware
> image which have this problem and workaround the issue in ath10k by ignoring
> the error code.
>
> I was also considering making this hw specific flag but as this is strictly a
> firmware issue it's best to handle this via a firmware feature flag so that it
> will be easy to disable the workaround.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied.

-- 
Kalle Valo
