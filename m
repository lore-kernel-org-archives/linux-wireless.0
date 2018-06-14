Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47840 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755166AbeFNPNf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 11:13:35 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: use crash_dump enum instead of magic numbers
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180611181935.155032-1-briannorris@chromium.org>
References: <20180611181935.155032-1-briannorris@chromium.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Message-Id: <20180614151334.AF0636074D@smtp.codeaurora.org> (sfid-20180614_171347_554455_03C387DC)
Date: Thu, 14 Jun 2018 15:13:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:

> The comments are telling you what the enum could tell you instead.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

7f8f72d8511a ath10k: use crash_dump enum instead of magic numbers

-- 
https://patchwork.kernel.org/patch/10458637/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
