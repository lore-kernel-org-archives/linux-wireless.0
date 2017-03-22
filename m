Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:33204 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752424AbdCVVyG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 17:54:06 -0400
Received: by mail-ot0-f181.google.com with SMTP id a12so106928197ota.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Mar 2017 14:54:05 -0700 (PDT)
Date: Wed, 22 Mar 2017 16:54:04 -0500
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
Subject: Re: [PATCH 3/3] soc: qcom: smd-rpm: Add msm8996 compatibility
Message-ID: <20170322215404.GC22585@hector.attlocal.net> (sfid-20170322_225551_896239_E681C6E9)
References: <20170320233544.1656-1-bjorn.andersson@linaro.org>
 <20170320233544.1656-3-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170320233544.1656-3-bjorn.andersson@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 20, 2017 at 04:35:44PM -0700, Bjorn Andersson wrote:
> With the RPM driver transitioned to RPMSG we can reuse the SMD-RPM
> driver ontop of GLINK for 8996, without any modifications.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Acked-by: Andy Gross <andy.gross@linaro.org>
