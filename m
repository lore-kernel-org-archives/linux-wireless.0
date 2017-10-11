Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:55145 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752123AbdJKNey (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 09:34:54 -0400
From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] rtl8xxxu: mark expected switch fall-throughs
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20171010193027.GA23108@embeddedor.com>
 <5f5f0f54-d901-90be-9025-0a1c4b909368@gmail.com>
 <87o9peqdo2.fsf@kamboji.qca.qualcomm.com>
Message-ID: <eb89f2ad-f2d5-b97f-c224-daf3953d912c@gmail.com> (sfid-20171011_153610_188983_FC21841F)
Date: Wed, 11 Oct 2017 09:34:51 -0400
MIME-Version: 1.0
In-Reply-To: <87o9peqdo2.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/2017 04:41 AM, Kalle Valo wrote:
> Jes Sorensen <jes.sorensen@gmail.com> writes:
> 
>> On 10/10/2017 03:30 PM, Gustavo A. R. Silva wrote:
>>> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>>> where we are expecting to fall through.
>>
>> While this isn't harmful, to me this looks like pointless patch churn
>> for zero gain and it's just ugly.
> 
> In general I find it useful to mark fall through cases. And it's just a
> comment with two words, so they cannot hurt your eyes that much.

I don't see them being harmful in the code, but I don't see them of much 
use either. If it happened as part of natural code development, fine. My 
objection is to people running around doing this systematically causing 
patch churn for little to zero gain.

Jes
