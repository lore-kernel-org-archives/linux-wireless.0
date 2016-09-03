Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56964 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752499AbcICKDz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 06:03:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/1,v2] rtlwifi: remove superfluous condition
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1470165981-6241-1-git-send-email-xypron.glpk@gmx.de>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heinrich Schuchardt <xypron.glpk@gmx.de>
Message-Id: <20160903100333.1536E6201B@smtp.codeaurora.org> (sfid-20160903_120425_870566_E3F9C315)
Date: Sat,  3 Sep 2016 10:03:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Heinrich Schuchardt <xypron.glpk@gmx.de> wrote:
> If sta == NULL, the changed line will not be reached.
> So no need to check that sta != NULL here.
> 
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, 1 patch applied to wireless-drivers-next.git:

f898005ff99f rtlwifi: remove superfluous condition

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9260253/
