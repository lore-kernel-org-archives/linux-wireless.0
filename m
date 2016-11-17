Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45916 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938799AbcKQGtV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 01:49:21 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ssb: Fix error routine when fallback SPROM fails
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161105190857.19386-1-Larry.Finger@lwfinger.net>
References: <20161105190857.19386-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Message-Id: <20161117064920.66DF7615E8@smtp.codeaurora.org> (sfid-20161117_074924_450727_52F5F46E)
Date: Thu, 17 Nov 2016 06:49:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> When there is a CRC error in the SPROM read from the device, the code
> attempts to handle a fallback SPROM. When this also fails, the driver
> returns zero rather than an error code.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>

Patch applied to wireless-drivers-next.git, thanks.

8052d7245b60 ssb: Fix error routine when fallback SPROM fails

-- 
https://patchwork.kernel.org/patch/9413783/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
