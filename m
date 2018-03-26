Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38122 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751868AbeCZPLw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 11:11:52 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3] wcn36xx: reduce verbosity of drivers messages
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180227140535.4794-1-rfried@codeaurora.org>
References: <20180227140535.4794-1-rfried@codeaurora.org>
To: Ramon Fried <rfried@codeaurora.org>
Cc: k.eugene.e@gmail.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, Ramon Fried <rfried@codeaurora.org>
Message-Id: <20180326151151.9D40560FF3@smtp.codeaurora.org> (sfid-20180326_171157_546885_9F1DCDE4)
Date: Mon, 26 Mar 2018 15:11:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ramon Fried <rfried@codeaurora.org> wrote:

> Whenever the WLAN interface is started the FW
> version and caps are printed.
> The caps now will be displayed only in debug mode.
> Firmware version will be displayed only once on first
> startup of the interface.
> 
> Change-Id: I4db6ea7f384fe15eebe4c3ddb1d1ccab00094332
> Signed-off-by: Ramon Fried <rfried@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

6b8a127bf66d wcn36xx: reduce verbosity of drivers messages

-- 
https://patchwork.kernel.org/patch/10245303/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
