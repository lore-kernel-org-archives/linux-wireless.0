Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43908 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757157AbcIGLdf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Sep 2016 07:33:35 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Andy Gross <andy.gross@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>,
        Eugene Krasnikov <k.eugene.e@gmail.com>,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH v4 1/4] soc: qcom: wcnss_ctrl: Stub wcnss_ctrl API
References: <1473200312-22438-1-git-send-email-bjorn.andersson@linaro.org>
        <20160907013958.GA6975@hector.attlocal.net>
Date: Wed, 07 Sep 2016 14:33:28 +0300
In-Reply-To: <20160907013958.GA6975@hector.attlocal.net> (Andy Gross's message
        of "Tue, 6 Sep 2016 20:39:58 -0500")
Message-ID: <874m5sx7uf.fsf@kamboji.qca.qualcomm.com> (sfid-20160907_133359_675743_C17448A1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Gross <andy.gross@linaro.org> writes:

> On Tue, Sep 06, 2016 at 03:18:29PM -0700, Bjorn Andersson wrote:
>> Stub the wcnss_ctrl API to allow compile testing wcnss function drivers.
>> 
>> Cc: Marcel Holtmann <marcel@holtmann.org>
>> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>> ---
>> 
>> There are no other pending changes colliding with this, so if Andy is okay with
>> this it could be merged through Kalle's tree - together with the other patches.
>> 
>> Marcel, with this applied we can drop the depends on QCOM_SMD from the
>> btqcomsmd driver as well.
>> 
>> Changes since v3:
>> - Added this patch to allow compile testing without SMD support after patch 2
>> 
>>  include/linux/soc/qcom/wcnss_ctrl.h | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>> 
>
> This is fine.
>
> Acked-by: Andy Gross <andy.gross@linaro.org>

Thanks. I'll then apply this to my ath.git tree and it will go to Linus
via net-next.

-- 
Kalle Valo
