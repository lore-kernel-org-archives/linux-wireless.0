Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50870 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbeDYIZP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 04:25:15 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rt2x00: rt2800: add antenna diversity for RT5370G
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180405122232.1694-1-xose.vazquez@gmail.com>
References: <20180405122232.1694-1-xose.vazquez@gmail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: unlisted-recipients:; (no To-header on input)
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        wireless newbie <wnewbie72@gmail.com>,
        linux wireless ml <linux-wireless@vger.kernel.org>
Message-Id: <20180425082515.42F036085F@smtp.codeaurora.org> (sfid-20180425_102520_863592_E3ABD4A1)
Date: Wed, 25 Apr 2018 08:25:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xose Vazquez Perez <xose.vazquez@gmail.com> wrote:

> RT5370G has hardware RX antenna diversity like RT5390R.
> Based on DPO_RT5572_LinuxSTA_2.6.1.3_20121022.tar.bz2 manufacturer driver:
> https://d86o2zu8ugzlg.cloudfront.net/mediatek-craft/drivers/DPO_RT5572_LinuxSTA_2.6.1.3_20121022.tar.bz2
> 
> Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> Cc: Helmut Schaa <helmut.schaa@googlemail.com>
> Cc: Gertjan van Wingerde <gwingerde@gmail.com>
> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
> Cc: wireless newbie <wnewbie72@gmail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux wireless ml <linux-wireless@vger.kernel.org>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

9d81ecde4dce rt2x00: rt2800: add antenna diversity for RT5370G

-- 
https://patchwork.kernel.org/patch/10324503/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
