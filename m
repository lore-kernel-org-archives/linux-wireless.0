Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42840 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932183AbdAASyJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 1 Jan 2017 13:54:09 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wlcore: fix spelling mistake in wl1271_warning
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161229201400.26830-1-colin.king@canonical.com>
References: <20161229201400.26830-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Shahar Patury <shaharp@ti.com>, Guy Mishol <guym@ti.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20170101185408.851B46141B@smtp.codeaurora.org> (sfid-20170101_195452_066437_4A75A47D)
Date: Sun,  1 Jan 2017 18:54:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> trivial fix to spelling mistake of function name in wl1271_warning,
> should be dynamic_ps_timeout instead of dyanmic_ps_timeout.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

a60db8e70313 wlcore: fix spelling mistake in wl1271_warning

-- 
https://patchwork.kernel.org/patch/9491377/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
