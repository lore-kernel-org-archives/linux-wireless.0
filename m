Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f170.google.com ([74.125.82.170]:36347 "EHLO
        mail-ot0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751768AbdCVVw1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 17:52:27 -0400
Received: by mail-ot0-f170.google.com with SMTP id i1so176585883ota.3
        for <linux-wireless@vger.kernel.org>; Wed, 22 Mar 2017 14:52:26 -0700 (PDT)
Date: Wed, 22 Mar 2017 16:52:24 -0500
From: Andy Gross <andy.gross@linaro.org>
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Brown <david.brown@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org
Subject: Re: [PATCH 1/3] soc: qcom: smd: Transition client drivers from smd
 to rpmsg
Message-ID: <20170322215224.GA22585@hector.attlocal.net> (sfid-20170322_225248_740517_125D5FE4)
References: <20170320233544.1656-1-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170320233544.1656-1-bjorn.andersson@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 20, 2017 at 04:35:42PM -0700, Bjorn Andersson wrote:
> By moving these client drivers to use RPMSG instead of the direct SMD
> API we can reuse them ontop of the newly added GLINK wire-protocol
> support found in the 820 and 835 Qualcomm platforms.
> 
> As the new (RPMSG-based) and old SMD implementations are mutually
> exclusive we have to change all client drivers in one commit, to make
> sure we have a working system before and after this transition.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---

For the qcom/smd parts:

Acked-by: Andy Gross <andy.gross@linaro.org>
