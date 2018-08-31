Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33492 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727973AbeHaTyk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 15:54:40 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] rtl8187: Fix warning generated when strncpy() destination
 length matches the sixe argument
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180820184831.24206-1-Larry.Finger@lwfinger.net>
References: <20180820184831.24206-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Message-Id: <20180831154635.000326049C@smtp.codeaurora.org> (sfid-20180831_174654_769958_179FB97D)
Date: Fri, 31 Aug 2018 15:46:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> In gcc8, when the 3rd argument (size) of a call to strncpy() matches the
> length of the first argument, the compiler warns of the possibility of an
> unterminated string. Using strlcpy() forces a null at the end.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers-next.git, thanks.

199ba9faca90 rtl8187: Fix warning generated when strncpy() destination length matches the sixe argument

-- 
https://patchwork.kernel.org/patch/10570639/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
