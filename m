Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:46260 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751038AbeDEM1i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Apr 2018 08:27:38 -0400
Date: Thu, 5 Apr 2018 14:25:52 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        wireless newbie <wnewbie72@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux wireless ml <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless: rt2x00: rt2800: add antenna diversity for
 RT5370G
Message-ID: <20180405122551.GA5104@redhat.com> (sfid-20180405_142741_474511_926409C3)
References: <20180405122232.1694-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180405122232.1694-1-xose.vazquez@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 05, 2018 at 02:22:32PM +0200, Xose Vazquez Perez wrote:
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

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
