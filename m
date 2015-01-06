Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:41772 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbbAFTHh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 14:07:37 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Rob Herring <rob.herring@linaro.org>,
	John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH V2 3/10] brcmfmac: Add support for bcm43340/1 wireless chipsets
References: <1419357863-2018-1-git-send-email-arend@broadcom.com>
Date: Tue, 06 Jan 2015 21:07:31 +0200
In-Reply-To: <1419357863-2018-1-git-send-email-arend@broadcom.com> (Arend van
	Spriel's message of "Tue, 23 Dec 2014 19:04:23 +0100")
Message-ID: <87sifnwwwc.fsf@kamboji.qca.qualcomm.com> (sfid-20150106_200741_364861_2E89B739)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> This patch adds support for the bcm43340 and bcm43341 wireless
> chipsets. These two chipsets are identical from wireless parts
> perspective. As such they use the same firmware image.
>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Rob Herring <rob.herring@linaro.org>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> [arend@broadcom.com: squash to single commit, remove 43341 chipid]
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> Changes since V1:
>   - change values for sdio device ids to hex format

Thanks, applied to wireless-drivers-next.git.

-- 
Kalle Valo
