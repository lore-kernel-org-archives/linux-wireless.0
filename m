Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:37098 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750968AbdIFXhI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Sep 2017 19:37:08 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFw0KNTKFrRHk5hthDGTGgL9BGt9G=x_m9Tz7m_-pN+NoA@mail.gmail.com>
References: <20170905.214143.826912481689443792.davem@davemloft.net> <CA+55aFw0KNTKFrRHk5hthDGTGgL9BGt9G=x_m9Tz7m_-pN+NoA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 6 Sep 2017 16:37:07 -0700
Message-ID: <CA+55aFwzYm5o98ZpbC1hOGfkcbYQaucuqZN6qB1f7_qW2CjVpQ@mail.gmail.com> (sfid-20170907_013728_005926_882D6172)
Subject: Re: [GIT] Networking
To: David Miller <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 6, 2017 at 4:27 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The firmware is iwlwifi-8000C-28.ucode from
> iwl7260-firmware-25.30.13.0-75.fc26.noarch, and the kernel reports
>
>   iwlwifi 0000:3a:00.0: loaded firmware version 27.455470.0 op_mode iwlmvm

And when I said "iwlwifi-8000C-28.ucode" I obviously meant
"iwlwifi-8000C-27.ucode".

At least it was _hopefully_ obvious from that "27" in the actual
version number it reports.

            Linus
