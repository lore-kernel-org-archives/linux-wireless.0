Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23861 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752852AbcICRhD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 13:37:03 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wcn36xx: Implement print_reg indication
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1467308789-23475-1-git-send-email-bjorn.andersson@linaro.org>
To: Bjorn Andersson <bjorn.andersson@linaro.org>
CC: Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        <wcn36xx@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Nicolas Dechesne <ndec@linaro.org>
Message-ID: <a6299e46b3644188a265828b8361e19e@euamsexm01a.eu.qualcomm.com> (sfid-20160903_193723_701257_D39100FA)
Date: Sat, 3 Sep 2016 19:36:53 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
> Some firmware versions sends a "print register indication", handle this
> by printing out the content.
> 
> Cc: Nicolas Dechesne <ndec@linaro.org>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>

This doesn't apply anymore, please rebase.

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9208737/
