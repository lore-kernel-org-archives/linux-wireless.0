Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35582 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbeH1Qc4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 12:32:56 -0400
Received: by mail-pl1-f193.google.com with SMTP id d9-v6so688461plr.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2018 05:41:28 -0700 (PDT)
Message-ID: <5B8542EF.6040405@sra-tohoku.co.jp> (sfid-20180828_144131_225339_3202DB24)
Date: Tue, 28 Aug 2018 21:41:19 +0900
From: Taketo Kabe <kabe@sra-tohoku.co.jp>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: prabhu <d.praabhu@gmail.com>, kvalo@codeaurora.org, m@bues.ch,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        kabe@sra-tohoku.co.jp
Subject: Re: [Regression]BCM4312 is broken in kernel 4.18[Root cause found]
References: <CAHnrWRruLuuPN+bYc4NqO515W8+wHoCPH16ULsnJV_JrD+9oEw@mail.gmail.com> <20180823201147.393b1d53@wiggum> <87lg8wjhqe.fsf@kamboji.qca.qualcomm.com> <f9553dfe-d89b-0760-29c6-cdad29b54f6f@lwfinger.net> <CAHnrWRp2n7W_Xb5kjT1ykcC0gL3ONc+dmqePAbKEEBHLd1euFA@mail.gmail.com> <25814b23-dcc9-3a20-7276-40818bbba6cb@lwfinger.net>
In-Reply-To: <25814b23-dcc9-3a20-7276-40818bbba6cb@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> @Pradhu & @Taketo: Attached is a new (improved?) patch for you to try. You need 
> to start from an unmodified 4.18 source. This patch should allow both of your 
> systems to work and avoid needing to revert Taketo's fix for his setup.
> 
> Thanks,
> Larry

Sorry for tha late reply.
Tested out the patch on clean 4.18.5 kernel source; it works as expected.

I also tried out proprietary firmware, but I couldn't reproduce a problem
mentioned in https://marc.info/?l=linux-wireless&m=153504546924558&w=2 .
The proprietary firmware works very sluggishly on my card (BCM4306)
and doesn't stand for practical use for unknown reason.
-- 
kabe
