Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59098 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751623AbeE3TUp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 15:20:45 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/9] qtnfmac: remove unused function declarations
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180529120005.21498-2-sergey.matyukevich.os@quantenna.com>
References: <20180529120005.21498-2-sergey.matyukevich.os@quantenna.com>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Dmitry Lebed <dlebed@quantenna.com>
Message-Id: <20180530192044.95E756074F@smtp.codeaurora.org> (sfid-20180530_212048_327953_929A7D7F)
Date: Wed, 30 May 2018 19:20:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:

> From: Andrey Shevchenko <ashevchenko@quantenna.com>
> 
> Functions qtnf_cmd_resp_parse and qtnf_cmd_resp_check have
> been removed. Remove their declarations as well.
> 
> Signed-off-by: Andrey Shevchenko <ashevchenko@quantenna.com>

9 patches applied to wireless-drivers-next.git, thanks.

6d89265d7841 qtnfmac: remove unused function declarations
d62b622ca409 qtnfmac: simplify notation
36e8c538b374 qtnfmac: decode error codes from firmware replies
9a3beeb5b73a qtnfmac: cleanup wdev structure between its uses
9e33e7fb4772 qtnfmac: improve control path timeout handling
b60769e2dff0 qtnfmac: fix firmware command error path
f5d2ff43b9ed qtnfmac: fix bg_scan_period parameter processing
40d68dbb986d qtnfmac: cancel scan on disconnect
480daa9cb62c qtnfmac: fix invalid STA state on EAPOL failure

-- 
https://patchwork.kernel.org/patch/10435101/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
