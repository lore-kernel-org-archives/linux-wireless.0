Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42960 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934727AbcI0Pqk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Sep 2016 11:46:40 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] rtlwifi: Add HAL_DEF_WOWLAN case to *_get_hw() routines
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1474736239-9826-2-git-send-email-Larry.Finger@lwfinger.net>
References: <1474736239-9826-2-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Message-Id: <20160927154638.7360C61283@smtp.codeaurora.org> (sfid-20160927_174711_625320_B54448EC)
Date: Tue, 27 Sep 2016 15:46:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Only rtl8821ae implements WOWLAN; however, the other drivers may receive
> a call requesting information about this mode. The other drivers need to
> ignore the request rather than logging that the default branch of the
> switch statement has been reached.
> 
> Reported by: Jean Delvare <jdelvare@suse.de>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

2 patches applied to wireless-drivers-next.git, thanks.

1cc49a5b5466 rtlwifi: Add HAL_DEF_WOWLAN case to *_get_hw() routines
8334ffdc8290 rtlwifi: Add explicit values to hw_variables enum

-- 
https://patchwork.kernel.org/patch/9349217/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
