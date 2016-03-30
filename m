Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:32945 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbcC3MMJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 08:12:09 -0400
Received: by mail-io0-f172.google.com with SMTP id a129so61737668ioe.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Mar 2016 05:12:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <871t6sb2g9.fsf@kamboji.qca.qualcomm.com>
References: <1459332895-4563-1-git-send-email-wnhuang@chromium.org>
	<CA+icZUVpMU0kjEKPpABU415Gv_EhFUkAGbXi82UVf8PbHnz9mw@mail.gmail.com>
	<CABicQ-Wwf6LrFujVw03TNvAF-ny4d2MfqP+GDL0ARRkg5EnT3Q@mail.gmail.com>
	<871t6sb2g9.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 30 Mar 2016 20:11:15 +0800
Message-ID: <CABicQ-U4xAvJbffVLD_HE6tmPRtQYpHuD60uNA2617JdUhbdog@mail.gmail.com> (sfid-20160330_141217_894464_B8414869)
Subject: Re: [PATCH RESEND] mwifiex: fix NULL pointer dereference error
From: Wei-Ning Huang <wnhuang@google.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: sedat.dilek@gmail.com,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Sameer Nanda <snanda@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 30, 2016 at 8:00 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Wei-Ning Huang <wnhuang@google.com> writes:
>
>> Kalle, can you help amend the message if this patch is accepted?
>
> Sure, I'll fix the typo in the commit log.
>
> But please try to avoid top posting, it makes it more difficult to
> follow the threads.
>
> --
> Kalle Valo

Noted, thanks for the reminder :)

Wei-Ning


-- 
Wei-Ning Huang, 黃偉寧 | Software Engineer, Google Inc., Taiwan |
wnhuang@google.com | Cell: +886 910-380678
