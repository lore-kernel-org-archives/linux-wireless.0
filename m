Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47240 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731793AbeHIRlf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 13:41:35 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] ssb: driver_gige: use true and false for boolean values
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180805000453.GA19115@embeddedor.com>
References: <20180805000453.GA19115@embeddedor.com>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Michael Buesch <m@bues.ch>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-Id: <20180809151613.6A1BE60B23@smtp.codeaurora.org> (sfid-20180809_171620_948967_42B60D8A)
Date: Thu,  9 Aug 2018 15:16:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> Return statements in functions returning bool should use true or false
> instead of an integer value.
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Reviewed-by: Michael Buesch <m@bues.ch>

Patch applied to wireless-drivers-next.git, thanks.

c7743c428111 ssb: driver_gige: use true and false for boolean values

-- 
https://patchwork.kernel.org/patch/10555985/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
