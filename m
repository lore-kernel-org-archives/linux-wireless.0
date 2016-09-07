Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:35154 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755928AbcIGBkB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 21:40:01 -0400
Received: by mail-oi0-f44.google.com with SMTP id s131so4114178oie.2
        for <linux-wireless@vger.kernel.org>; Tue, 06 Sep 2016 18:40:01 -0700 (PDT)
Date: Tue, 6 Sep 2016 20:39:58 -0500
From: Andy Gross <andy.gross@linaro.org>
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH v4 1/4] soc: qcom: wcnss_ctrl: Stub wcnss_ctrl API
Message-ID: <20160907013958.GA6975@hector.attlocal.net> (sfid-20160907_034024_502646_94FDAB52)
References: <1473200312-22438-1-git-send-email-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1473200312-22438-1-git-send-email-bjorn.andersson@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 06, 2016 at 03:18:29PM -0700, Bjorn Andersson wrote:
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
> 
> Changes since v3:
> - Added this patch to allow compile testing without SMD support after patch 2
> 
>  include/linux/soc/qcom/wcnss_ctrl.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 

This is fine.

Acked-by: Andy Gross <andy.gross@linaro.org>
