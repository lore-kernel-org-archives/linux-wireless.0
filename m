Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:32822 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932133AbcIFXMr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 19:12:47 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH v4 1/4] soc: qcom: wcnss_ctrl: Stub wcnss_ctrl API
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1473200312-22438-1-git-send-email-bjorn.andersson@linaro.org>
Date: Wed, 7 Sep 2016 00:12:42 +0100
Cc: Andy Gross <andy.gross@linaro.org>,
        Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, wcn36xx@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Message-Id: <4378F670-3784-457F-A070-4B56A8178E68@holtmann.org> (sfid-20160907_011312_762594_D858073B)
References: <1473200312-22438-1-git-send-email-bjorn.andersson@linaro.org>
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bjorn,

> Stub the wcnss_ctrl API to allow compile testing wcnss function drivers.
> 
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
> 
> There are no other pending changes colliding with this, so if Andy is okay with
> this it could be merged through Kalle's tree - together with the other patches.
> 
> Marcel, with this applied we can drop the depends on QCOM_SMD from the
> btqcomsmd driver as well.

sounds great. As soon as this lands in net-next, then please send a patch to remove the dependency. I will pull in net-next into bluetooth-next then.

Regards

Marcel
