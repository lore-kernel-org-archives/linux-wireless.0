Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46350 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754171AbcK3R3B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Nov 2016 12:29:01 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
        briselec@gmail.com
Subject: Re: [PATCH 0/1] rtl8xxxu: Workaround for 8192eu/8723bu not reconnecting
References: <20161129235902.11882-1-Jes.Sorensen@redhat.com>
        <87mvghtkwd.fsf@kamboji.qca.qualcomm.com>
        <1480514067.29540.54.camel@coelho.fi> <wrfja8ch6l1o.fsf@redhat.com>
Date: Wed, 30 Nov 2016 19:27:57 +0200
In-Reply-To: <wrfja8ch6l1o.fsf@redhat.com> (Jes Sorensen's message of "Wed, 30
        Nov 2016 10:32:03 -0500")
Message-ID: <87inr4ubc2.fsf@kamboji.qca.qualcomm.com> (sfid-20161130_182905_669651_C95688A1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> writes:

> Luca Coelho <luca@coelho.fi> writes:
>> On Wed, 2016-11-30 at 10:46 +0200, Kalle Valo wrote:
>>> Jes.Sorensen@redhat.com writes:
>>> 
>>> > From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>> > 
>>> > Hi,
>>> > 
>>> > This patch works around the issue with 8192eu and 8723bu devices not
>>> > being able to reconnect. It is still not clear why this fails, and
>>> > looking at rtlwifi it does issue the command for 8192ee and 8723be
>>> > devices.
>>> > 
>>> > Until we have a better idea of what is going on, I have commented out
>>> > the offending code. I prefer not deleting it until we have a better
>>> > understanding of why this is causing issues.
>>> > 
>>> > Credits to Barry Day for tracking down and isolating the issue.
>>> > 
>>> > Kalle, not sure if this can make it to 4.9, but if it's possible it
>>> > would be ideal since this is causing real issues in the field.
>>> 
>>> For 4.9 this is too late, sorry. I'll queue this to 4.10.
>>
>> You should then CC stable so it gets into 4.9.x when it reaches 4.10.
>
> Yeah good idea - Kalle do you want me to repost it with the CC line or
> are you happy to add it?

I can add it. To which stable releases should this go to?

-- 
Kalle Valo
