Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57618 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753174AbcICKLE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 06:11:04 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/1] mwifiex: key_material_v2 remove superfluous condition
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1469967081-3937-1-git-send-email-xypron.glpk@gmx.de>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heinrich Schuchardt <xypron.glpk@gmx.de>
Message-Id: <20160903100052.D26F461B13@smtp.codeaurora.org> (sfid-20160903_121207_718082_F8CF4FB6)
Date: Sat,  3 Sep 2016 10:00:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Heinrich Schuchardt <xypron.glpk@gmx.de> wrote:
> We are using mac as source address in a memcpy.
> In the lines below we can assume mac is not NULL.
> 
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
> Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

b0d80f19c14f mwifiex: key_material_v2 remove superfluous condition

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9253367/
