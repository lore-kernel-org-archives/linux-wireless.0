Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56602 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752240AbcICKDT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 06:03:19 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/1] mwifiex: remove superfluous condition
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1469961555-2123-1-git-send-email-xypron.glpk@gmx.de>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heinrich Schuchardt <xypron.glpk@gmx.de>
Message-Id: <20160903100016.F332B61AC4@smtp.codeaurora.org> (sfid-20160903_120322_555915_2031D8DA)
Date: Sat,  3 Sep 2016 10:00:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Heinrich Schuchardt <xypron.glpk@gmx.de> wrote:
> for_each_property_of_node is only executed if the
> property prop is not NULL.
> 
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
> Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

2f69e67058fb mwifiex: remove superfluous condition

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9253329/
