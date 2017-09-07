Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50294 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751666AbdIGQgz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Sep 2017 12:36:55 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Luca Coelho <luca@coelho.fi>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH] iwlwifi: mvm: only send LEDS_CMD when the FW supports it
References: <CA+55aFxjHSW7v4Ttu7mGPkxdGpR-WtVoxDT5qtwxUC-Dge5a5A@mail.gmail.com>
        <20170907075152.4522-1-luca@coelho.fi>
        <877exan0nq.fsf@kamboji.qca.qualcomm.com>
        <CA+55aFyeEwg7vd8FPHqG+4d7KbJ6ke4NDwhd+8y=_auRApyvmw@mail.gmail.com>
Date: Thu, 07 Sep 2017 19:36:43 +0300
In-Reply-To: <CA+55aFyeEwg7vd8FPHqG+4d7KbJ6ke4NDwhd+8y=_auRApyvmw@mail.gmail.com>
        (Linus Torvalds's message of "Thu, 7 Sep 2017 09:13:00 -0700")
Message-ID: <8760culb38.fsf@kamboji.qca.qualcomm.com> (sfid-20170907_183716_024165_8DD9C123)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Sep 7, 2017 at 5:39 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>> Linus, do you want to apply this directly or should we take it via the
>> normal route (wireless-drivers -> net)? If your prefer the latter when
>> I'm planning to submit this to Dave in a day or two and expecting it to
>> get to your tree in about a week, depending of course what is Dave's
>> schedule.
>
> Since we have a workaround for the problem, let's just go through the
> regular channels. As long as I get the fix through David before the
> merge window closes, I'm happy.

Ok, I'll aim to send the pull request to Dave tomorrow.

-- 
Kalle Valo
