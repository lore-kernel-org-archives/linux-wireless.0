Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39052 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750866AbeCJQpR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 11:45:17 -0500
Subject: Re: [PATCH] wcn36xx: calculate DXE control registers values
To: Kalle Valo <kvalo@codeaurora.org>
Cc: k.eugene.e@gmail.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org
References: <20180304163134.4464-1-rfried@codeaurora.org>
 <874llocldz.fsf@kamboji.qca.qualcomm.com>
From: Ramon Fried <rfried@codeaurora.org>
Message-ID: <6d053bfd-d358-9e71-166e-885ce865f570@codeaurora.org> (sfid-20180310_174521_306698_20FCF2F9)
Date: Sat, 10 Mar 2018 18:45:13 +0200
MIME-Version: 1.0
In-Reply-To: <874llocldz.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 3/10/2018 11:47 AM, Kalle Valo wrote:
> Ramon Fried <rfried@codeaurora.org> writes:
>
>> DXE descriptor control registers used hardcoded magic values. Added
>> bit definitions of the control register and calculate this values in
>> compilation for clarity.
>>
>> Signed-off-by: Ramon Fried <rfried@codeaurora.org>
> I assume that the values are still the same and there are no functional
> changes? If yes, I'll add that to the commit log when I commit this.
Yes. I double verified this. the values are the same.
