Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51114 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938436AbdAIUey (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 15:34:54 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [GIT] Networking
References: <20170108.223847.1035900535306187665.davem@davemloft.net>
        <CA+55aFzjL6Tf7JazeZtbi9UARhqofWU8xzYm0rbdAeCsD+nMPw@mail.gmail.com>
Date: Mon, 09 Jan 2017 22:34:43 +0200
In-Reply-To: <CA+55aFzjL6Tf7JazeZtbi9UARhqofWU8xzYm0rbdAeCsD+nMPw@mail.gmail.com>
        (Linus Torvalds's message of "Mon, 9 Jan 2017 12:08:02 -0800")
Message-ID: <87r34ct1jw.fsf@kamboji.qca.qualcomm.com> (sfid-20170109_213532_267369_83BD3702)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Sun, Jan 8, 2017 at 7:38 PM, David Miller <davem@davemloft.net> wrote:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
>
> Hmm. This still doesn't contain the rtlwifi oops fix that was posted
> back before christmas.
>
> Kalle said it was applied to the wireless-drivers tree as commit
> 60f59ce02785 in his tree, but it's never gotten to me.
>
> What's up? It's three weeks later, and people are hitting the bug.

You mean this one:

60f59ce02785 rtlwifi: rtl_usb: Fix missing entry in USB driver's private data

I accidentally missed the patch during my holiday pull request,
committed the patch late, and I haven't sent a new pull request since.
Also the commit log didn't mention anything about an oops, only about
"missing an entry", so I didn't realise it was a critical fix.

Sorry about that, I'll send a new pull request to Dave first thing
tomorrow. It's too late now for me.

-- 
Kalle Valo
