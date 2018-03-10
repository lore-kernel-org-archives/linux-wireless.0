Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43790 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751969AbeCJJrk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 04:47:40 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Ramon Fried <rfried@codeaurora.org>
Cc: k.eugene.e@gmail.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wcn36xx: calculate DXE control registers values
References: <20180304163134.4464-1-rfried@codeaurora.org>
Date: Sat, 10 Mar 2018 11:47:36 +0200
In-Reply-To: <20180304163134.4464-1-rfried@codeaurora.org> (Ramon Fried's
        message of "Sun, 4 Mar 2018 18:31:34 +0200")
Message-ID: <874llocldz.fsf@kamboji.qca.qualcomm.com> (sfid-20180310_104744_569757_AF7D35BB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ramon Fried <rfried@codeaurora.org> writes:

> DXE descriptor control registers used hardcoded magic values. Added
> bit definitions of the control register and calculate this values in
> compilation for clarity.
>
> Signed-off-by: Ramon Fried <rfried@codeaurora.org>

I assume that the values are still the same and there are no functional
changes? If yes, I'll add that to the commit log when I commit this.

-- 
Kalle Valo
