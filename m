Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f178.google.com ([74.125.82.178]:33849 "EHLO
        mail-ot0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751367AbdCVVxm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 17:53:42 -0400
Received: by mail-ot0-f178.google.com with SMTP id o24so176259430otb.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Mar 2017 14:53:41 -0700 (PDT)
Date: Wed, 22 Mar 2017 16:53:39 -0500
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
Subject: Re: [PATCH 2/3] soc: qcom: smd: Remove standalone driver
Message-ID: <20170322215339.GB22585@hector.attlocal.net> (sfid-20170322_225551_287822_E95E2355)
References: <20170320233544.1656-1-bjorn.andersson@linaro.org>
 <20170320233544.1656-2-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170320233544.1656-2-bjorn.andersson@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 20, 2017 at 04:35:43PM -0700, Bjorn Andersson wrote:
> Remove the standalone SMD implementation as we have transitioned the
> client drivers to use the RPMSG based one.
> 
> Also remove all dependencies on QCOM_SMD from Kconfig files, in order to
> keep them selectable in the absence of the removed symbol.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Acked-by: Andy Gross <andy.gross@linaro.org>
