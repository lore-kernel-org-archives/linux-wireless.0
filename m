Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52648 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751437AbcJJJVi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Oct 2016 05:21:38 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Ola Olsson <ola1olsson@gmail.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        Ola Olsson <ola.olsson@sonymobile.com>
Subject: Re: [PATCH] Report scan_abort as part of iw phy
References: <1475934036-5981-1-git-send-email-ola1olsson@gmail.com>
Date: Mon, 10 Oct 2016 12:13:29 +0300
In-Reply-To: <1475934036-5981-1-git-send-email-ola1olsson@gmail.com> (Ola
        Olsson's message of "Sat, 8 Oct 2016 15:40:36 +0200")
Message-ID: <87k2dg1s92.fsf@purkki.adurom.net> (sfid-20161010_112142_666363_6F7B1880)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ola Olsson <ola1olsson@gmail.com> writes:

> nl80211: abort_scan has not been reported under the 'Supported commands'
> category when calling iw phy. Add that.
>
> Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
> ---
>  net/wireless/nl80211.c | 1 +
>  1 file changed, 1 insertion(+)

You should prefix the title with "cfg80211: " (or "nl80211: ", not
really sure which one is more suitable).

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#subject_name

-- 
Kalle Valo
