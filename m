Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:52844 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752867AbdC0XE0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Mar 2017 19:04:26 -0400
Date: Mon, 27 Mar 2017 16:04:00 -0700 (PDT)
Message-Id: <20170327.160400.1285256003980361221.davem@davemloft.net> (sfid-20170328_010620_463744_771695A2)
To: bjorn.andersson@linaro.org
Cc: marcel@holtmann.org, gustavo@padovan.org, johan.hedberg@gmail.com,
        k.eugene.e@gmail.com, kvalo@codeaurora.org, andy.gross@linaro.org,
        david.brown@linaro.org, arnd@arndb.de,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org
Subject: Re: [PATCH 1/3] soc: qcom: smd: Transition client drivers from smd
 to rpmsg
From: David Miller <davem@davemloft.net>
In-Reply-To: <20170327225836.GL20094@minitux>
References: <20170322215733.GH20094@minitux>
        <20170323.165613.802100008000968298.davem@davemloft.net>
        <20170327225836.GL20094@minitux>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bjorn Andersson <bjorn.andersson@linaro.org>
Date: Mon, 27 Mar 2017 15:58:37 -0700

> I'm sorry, but I can't figure out how to reproduce this.

All of my builds are "make allmodconfig" so it should be easy to reproduce.
