Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58452 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752375AbeB1Lki (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 06:40:38 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] brcmfmac: add possibility to obtain firmware error
References: <1519774940-20793-1-git-send-email-arend.vanspriel@broadcom.com>
        <1519774940-20793-2-git-send-email-arend.vanspriel@broadcom.com>
        <5A967163.7010206@broadcom.com>
Date: Wed, 28 Feb 2018 13:40:34 +0200
In-Reply-To: <5A967163.7010206@broadcom.com> (Arend van Spriel's message of
        "Wed, 28 Feb 2018 10:07:47 +0100")
Message-ID: <87k1uxgx59.fsf@codeaurora.org> (sfid-20180228_124042_746169_D98F889F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 2/28/2018 12:42 AM, Arend van Spriel wrote:
>> The feature module needs to evaluate the actual firmware error returned
>> upon a control command. This adds a field to struct brcmf_if in which
>> the error code is stored whenever a firmware error occurs.
>
> Hi Kalle,
>
> Can you drop this one. It was way too late for me so I screwed it up.
> If needed I will resend both patches. Let me know.

I see that you submitted v2 already so I'll drop both patches 1 and 2.

-- 
Kalle Valo
