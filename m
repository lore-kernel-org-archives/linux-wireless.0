Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60972 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbeHXL47 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 07:56:59 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Michael =?utf-8?Q?B=C3=BCsch?= <m@bues.ch>
Cc: prabhu <d.praabhu@gmail.com>, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org
Subject: Re: [Regression]BCM4312 is broken in kernel 4.18[Root cause found]
References: <CAHnrWRruLuuPN+bYc4NqO515W8+wHoCPH16ULsnJV_JrD+9oEw@mail.gmail.com>
        <20180823201147.393b1d53@wiggum>
Date: Fri, 24 Aug 2018 11:23:21 +0300
In-Reply-To: <20180823201147.393b1d53@wiggum> ("Michael \=\?utf-8\?Q\?B\=C3\=BCs\?\=
 \=\?utf-8\?Q\?ch\=22's\?\= message of
        "Thu, 23 Aug 2018 20:11:47 +0200")
Message-ID: <87lg8wjhqe.fsf@kamboji.qca.qualcomm.com> (sfid-20180824_102328_894384_661604D0)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael B=C3=BCsch <m@bues.ch> writes:

> On Thu, 23 Aug 2018 23:00:53 +0530
> prabhu <d.praabhu@gmail.com> wrote:
>
>> The following commits introduce this regression in 4.18
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commi=
t/?id=3D66cffd6daab76caebab26eb803b92182414fc182
>
> Ok. Kalle, can you please revert the commit
> 66cffd6daab76caebab26eb803b92182414fc182
> ?

Please submit a proper patch with an explanation why it needs to be
reverted.

--=20
Kalle Valo
