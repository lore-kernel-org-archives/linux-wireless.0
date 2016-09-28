Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41047 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932133AbcI1K14 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 06:27:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: MAINTAINERS: hostap: Mark the Host AP driver obsolete
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160927154258.GA6443@w1.fi>
References: <20160927154258.GA6443@w1.fi>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20160928102755.AFBF361812@smtp.codeaurora.org> (sfid-20160928_122800_431640_7E1BE303)
Date: Wed, 28 Sep 2016 10:27:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen <j@w1.fi> wrote:
> This is old code for old hardware and it is not really accurate to claim
> this to be maintained anymore. Change the status to "Obsolete" to make
> it clearer that minor cleanup and other unnecessary changes from
> automated tools is not necessarily beneficial and has larger risk of
> breaking something without being quickly noticed due to lack of testing.
> 
> In addition, remove the old mailing list that does not work anymore and
> point the web-page to a more accurate URL.
> 
> Signed-off-by: Jouni Malinen <j@w1.fi>

Patch applied to wireless-drivers-next.git, thanks.

ffd74aca44b7 MAINTAINERS: hostap: Mark the Host AP driver obsolete

-- 
https://patchwork.kernel.org/patch/9352117/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
