Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51352 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753791AbdLGNY6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 08:24:58 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V2] wlcore,
 wl1251: fix spelling: "Couldnt" -> "Couldn't" and remove error on
 -ENOMEM
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171201100258.10029-1-colin.king@canonical.com>
References: <20171201100258.10029-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20171207132457.EF324607E8@smtp.codeaurora.org> (sfid-20171207_142607_008115_81A8EAC6)
Date: Thu,  7 Dec 2017 13:24:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Trivial fix to spelling mistake in error message text.  Also remove the
> error message on an kzalloc failure as this is redundant.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

c4ee30a280b1 wlcore, wl1251: fix spelling: "Couldnt" -> "Couldn't" and remove error on -ENOMEM

-- 
https://patchwork.kernel.org/patch/10086741/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
