Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49220 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754903AbdLGNYO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 08:24:14 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wlcore: allow elp during wowlan suspend
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <8665E2433BC68541A24DFFCA87B70F5B364A3796@DFRE01.ent.ti.com>
References: <8665E2433BC68541A24DFFCA87B70F5B364A3796@DFRE01.ent.ti.com>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-Id: <20171207132414.227C06022C@smtp.codeaurora.org> (sfid-20171207_142529_053010_00381483)
Date: Thu,  7 Dec 2017 13:24:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Reizer, Eyal" <eyalr@ti.com> wrote:

> when enabling wowlan and entering suspend the last write to the firmware
> allowing it to go into elp mode was not completing before suspend, leaving
> the firmware running in full active mode consuming high power.
> Use an immediate call instead of a work queue for this last access
> allowing the firmware to go into power save during wowlan uspend.
> 
> Signed-off-by: Eyal Reizer <eyalr@ti.com>

Patch applied to wireless-drivers-next.git, thanks.

37bf241b8e7b wlcore: allow elp during wowlan suspend

-- 
https://patchwork.kernel.org/patch/10078927/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
