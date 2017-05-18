Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55646 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754754AbdERNlo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 09:41:44 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wlcore: use memdup_user
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <69124563157776eb4187fa35b0161dc8675ebeaf.1493781907.git.geliangtang@gmail.com>
References: <69124563157776eb4187fa35b0161dc8675ebeaf.1493781907.git.geliangtang@gmail.com>
To: Geliang Tang <geliangtang@gmail.com>
Cc: Colin Ian King <colin.king@canonical.com>,
        Geliang Tang <geliangtang@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20170518134144.2AE9260F5C@smtp.codeaurora.org> (sfid-20170518_154249_877763_9330EA35)
Date: Thu, 18 May 2017 13:41:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Geliang Tang <geliangtang@gmail.com> wrote:
> Use memdup_user() helper instead of open-coding to simplify the code.
> 
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

6a01d48d47c8 wlcore: use memdup_user

-- 
https://patchwork.kernel.org/patch/9715005/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
