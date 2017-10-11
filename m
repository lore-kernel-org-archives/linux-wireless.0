Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56964 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757150AbdJKIl4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 04:41:56 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: mark expected switch fall-throughs
References: <20171010193027.GA23108@embeddedor.com>
        <5f5f0f54-d901-90be-9025-0a1c4b909368@gmail.com>
Date: Wed, 11 Oct 2017 11:41:49 +0300
In-Reply-To: <5f5f0f54-d901-90be-9025-0a1c4b909368@gmail.com> (Jes Sorensen's
        message of "Tue, 10 Oct 2017 15:35:10 -0400")
Message-ID: <87o9peqdo2.fsf@kamboji.qca.qualcomm.com> (sfid-20171011_104225_537845_DA7D6C89)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <jes.sorensen@gmail.com> writes:

> On 10/10/2017 03:30 PM, Gustavo A. R. Silva wrote:
>> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>> where we are expecting to fall through.
>
> While this isn't harmful, to me this looks like pointless patch churn
> for zero gain and it's just ugly.

In general I find it useful to mark fall through cases. And it's just a
comment with two words, so they cannot hurt your eyes that much.

-- 
Kalle Valo
