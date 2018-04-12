Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39296 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751863AbeDLMia (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 08:38:30 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Daniel Mack <daniel@zonque.org>
Cc: Loic Poulain <loic.poulain@linaro.org>,
        wcn36xx@lists.infradead.org, Ramon Fried <rfried@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH] wcn36xx: pass correct BSS index when deleting BSS keys
References: <20180412111311.28809-1-daniel@zonque.org>
        <CAMZdPi98WH59nxV08wHcyAoDB06T3ptNT=E9C8S6RK_Yg1pKnQ@mail.gmail.com>
        <62942f8b-3e02-868f-6cb1-7423cd44b828@zonque.org>
        <877epcr58x.fsf@codeaurora.org>
        <94a0d7fa-04f6-2c9a-7aa4-1d3ddc28ee8c@zonque.org>
Date: Thu, 12 Apr 2018 15:38:25 +0300
In-Reply-To: <94a0d7fa-04f6-2c9a-7aa4-1d3ddc28ee8c@zonque.org> (Daniel Mack's
        message of "Thu, 12 Apr 2018 14:16:57 +0200")
Message-ID: <87604wioqm.fsf@purkki.adurom.net> (sfid-20180412_143834_326463_5D15BB81)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Mack <daniel@zonque.org> writes:

>>> Yeah, sorry. I did that intentionally, but missed to mention it in the
>>> commit log.
>> 
>> I can add that to the commit log, just tell me what to add.
>
> I'll resend, hang on :)

Even better, thanks.

-- 
Kalle Valo
