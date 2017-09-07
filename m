Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:36124 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754958AbdIGQNB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Sep 2017 12:13:01 -0400
MIME-Version: 1.0
In-Reply-To: <877exan0nq.fsf@kamboji.qca.qualcomm.com>
References: <CA+55aFxjHSW7v4Ttu7mGPkxdGpR-WtVoxDT5qtwxUC-Dge5a5A@mail.gmail.com>
 <20170907075152.4522-1-luca@coelho.fi> <877exan0nq.fsf@kamboji.qca.qualcomm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 7 Sep 2017 09:13:00 -0700
Message-ID: <CA+55aFyeEwg7vd8FPHqG+4d7KbJ6ke4NDwhd+8y=_auRApyvmw@mail.gmail.com> (sfid-20170907_181325_917789_75367143)
Subject: Re: [PATCH] iwlwifi: mvm: only send LEDS_CMD when the FW supports it
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Luca Coelho <luca@coelho.fi>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 7, 2017 at 5:39 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Linus, do you want to apply this directly or should we take it via the
> normal route (wireless-drivers -> net)? If your prefer the latter when
> I'm planning to submit this to Dave in a day or two and expecting it to
> get to your tree in about a week, depending of course what is Dave's
> schedule.

Since we have a workaround for the problem, let's just go through the
regular channels. As long as I get the fix through David before the
merge window closes, I'm happy.

              Linus
