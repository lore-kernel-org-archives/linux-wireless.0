Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:57989 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667AbYICDDe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:03:34 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1524605yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 02 Sep 2008 20:03:32 -0700 (PDT)
Message-ID: <43e72e890809022003gfd462d2ma8d68f032754c121@mail.gmail.com> (sfid-20080903_050336_399636_2155B31B)
Date: Tue, 2 Sep 2008 20:03:32 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: at76_usb.[ch] gone fishing from wireless-testing ?
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <87vdxedje8.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890809021953o29c6ba53wcdf7630d4ff10b30@mail.gmail.com>
	 <87vdxedje8.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 2, 2008 at 7:59 PM, Kalle Valo <kalle.valo@nokia.com> wrote:
> Luis R. Rodriguez <mcgrof@gmail.com> writes:
>
>> A few times now I've git-fetch'd origin and noticed at76_usb.[ch]
>> missing on origin/master. Strange, wondering if you're aware of any
>> such type of issues or its just me.
>
> Good point, I don't see it either. But at76_usb is quite broken
> currently, so maybe John decided just to drop it? Good choice, at
> least for now.
>
> And it's not just that, also -wl suffix is missing from the version.
>
> My HEAD is currently:
>
> commit 18c8adeb0244f823ba78a51e23f813fe68bc3c54
> Author: Michael Buesch <mb@bu3sch.de>
> Date:   Thu Aug 28 19:33:40 2008 +0200
>
>    b43: Rewrite TX power adjustment

I'm at:

commit 908dd0b965e64fcc2eb64152bac65f2876c34e0b
Author: Senthil Balasubramanian <senthilkumar@atheros.com>
Date:   Mon Sep 1 19:58:20 2008 +0530
    ath9: Fix ath_rx_flush_tid() for IRQs disabled kernel warning message.

Reason I find it strange is on one box it went through and I still see
history for it, and in another I don't. I was going to do a fresh pull
to test but figure I rather ask as bandwidth is crummy at work.

  Luis
