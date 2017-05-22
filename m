Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58706 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754643AbdEVJD4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 05:03:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: b43: Add missing MODULE_FIRMWARE()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170504092752.2422-1-tiwai@suse.de>
References: <20170504092752.2422-1-tiwai@suse.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Message-Id: <20170522090355.9C07F60A09@smtp.codeaurora.org> (sfid-20170522_110454_890700_59B4B081)
Date: Mon, 22 May 2017 09:03:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Takashi Iwai <tiwai@suse.de> wrote:
> Some firmware entries were forgotten to be added via MODULE_FIRMWARE(), which
> may result in the non-functional state when the driver is loaded in initrd.
> 
> Link: http://bugzilla.opensuse.org/show_bug.cgi?id=1037344
> Fixes: 15be8e89cdd9 ("b43: add more bcma cores")
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Patch applied to wireless-drivers-next.git, thanks.

3c89a72ad80c b43: Add missing MODULE_FIRMWARE()

-- 
https://patchwork.kernel.org/patch/9711225/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
