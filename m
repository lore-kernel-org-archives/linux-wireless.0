Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59688 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754963AbdLGNOj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 08:14:39 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: Convert individual interrupt results to struct
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171112200645.26284-1-Larry.Finger@lwfinger.net>
References: <20171112200645.26284-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Message-Id: <20171207131439.3B942608C9@smtp.codeaurora.org> (sfid-20171207_141538_199586_5F1F1F96)
Date: Thu,  7 Dec 2017 13:14:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> With the RTL8822BE and later devices, the number of interrupt vectors
> has grown from 2 to 4. At this point, saving and passing those vectors
> in a struct makes more sense than using individual scaler variables.
> 
> In two of the drivers, code to process the second of the interrupt
> registers was included, but commented out. This patch removes those
> useless sections.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

78aa6012033f rtlwifi: Convert individual interrupt results to struct

-- 
https://patchwork.kernel.org/patch/10054899/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
