Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ed1-f67.google.com ([209.85.208.67]:33176 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbeH0PQw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Aug 2018 11:16:52 -0400
Received: by mail-ed1-f67.google.com with SMTP id h9-v6so10202814edr.0
        for <linux-wireless@vger.kernel.org>; Mon, 27 Aug 2018 04:30:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAHnrWRruLuuPN+bYc4NqO515W8+wHoCPH16ULsnJV_JrD+9oEw@mail.gmail.com>
 <20180823201147.393b1d53@wiggum> <87lg8wjhqe.fsf@kamboji.qca.qualcomm.com>
 <f9553dfe-d89b-0760-29c6-cdad29b54f6f@lwfinger.net> <CAHnrWRp2n7W_Xb5kjT1ykcC0gL3ONc+dmqePAbKEEBHLd1euFA@mail.gmail.com>
 <25814b23-dcc9-3a20-7276-40818bbba6cb@lwfinger.net>
In-Reply-To: <25814b23-dcc9-3a20-7276-40818bbba6cb@lwfinger.net>
From: prabhu <d.praabhu@gmail.com>
Date: Mon, 27 Aug 2018 17:00:23 +0530
Message-ID: <CAHnrWRo-Edm+bSJ_1EKNYkPR2zKVnvfoTpaLK+uY1bw4JS7ZjQ@mail.gmail.com> (sfid-20180827_133038_759250_9C9F1145)
Subject: Re: [Regression]BCM4312 is broken in kernel 4.18[Root cause found]
To: Larry.Finger@lwfinger.net
Cc: kabe@sra-tohoku.co.jp, kvalo@codeaurora.org, m@bues.ch,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry,

Applied on a clean 4.18.4 source and tested.
It works for me.
On Sun, Aug 26, 2018 at 9:44 PM Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
> On 08/26/2018 02:23 AM, prabhu wrote:
> > Larry,
> >
> > Upgrading the firmware didn't fix the issue.
> >
> > The patch fixes it. My system has been running without any issues
> > since yesterday.
>
> I did not think the new firmware would help, but it had to be tried. Thanks for
> the testing.
>
> @Pradhu & @Taketo: Attached is a new (improved?) patch for you to try. You need
> to start from an unmodified 4.18 source. This patch should allow both of your
> systems to work and avoid needing to revert Taketo's fix for his setup.
>
> Thanks,
>
> Larry
>
>
