Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44742 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbeH1SUC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 14:20:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] ath10k: Support extended board data download for
 dual-band QCA9984
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180824141221.3661-1-murugana@codeaurora.org>
References: <20180824141221.3661-1-murugana@codeaurora.org>
To: Sathishkumar Muruganandam <murugana@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Sathishkumar Muruganandam <murugana@codeaurora.org>
Message-Id: <20180828142806.D1C9A6044E@smtp.codeaurora.org> (sfid-20180828_162816_088484_3CE56F58)
Date: Tue, 28 Aug 2018 14:28:06 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sathishkumar Muruganandam <murugana@codeaurora.org> wrote:

> Just moving functions down in the file, no functional changes.
> 
> Signed-off-by: Sathishkumar Muruganandam <murugana@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Try to make the patch titles always unique, I changed this in pending branch
to:

    ath10k: refactoring needed for extended board data download

-- 
https://patchwork.kernel.org/patch/10575359/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
