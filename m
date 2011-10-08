Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50941 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab1JHTzs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Oct 2011 15:55:48 -0400
Received: by eye27 with SMTP id 27so471177eye.19
        for <linux-wireless@vger.kernel.org>; Sat, 08 Oct 2011 12:55:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318103127.9690.46.camel@cumari>
References: <1318004245-18347-1-git-send-email-shahar@wizery.com>
 <1318004434.3988.16.camel@jlt3.sipsolutions.net> <CANCvt+6JkxnE6Z7soUuhQSbzpxuxYUNC7z0vv+jn-sH+jpY4Qg@mail.gmail.com>
 <1318022253.3549.108.camel@cumari> <CA+XVXfd+vN7b=oYrysPCuynAgy5=4SgRHuznJRW0h+6ez7YqsQ@mail.gmail.com>
 <1318103127.9690.46.camel@cumari>
From: Arik Nemtsov <anamtsov@gmail.com>
Date: Sat, 8 Oct 2011 21:55:32 +0200
Message-ID: <CA+XVXff_5isgfReUYXh8K1nNTtAqnFp5tb36EKLL7MBaTka+UQ@mail.gmail.com> (sfid-20111008_215553_032414_F01287DB)
Subject: Re: [PATCH] wl12xx: remove warning message during IBSS Tx
To: Luciano Coelho <coelho@ti.com>
Cc: Shahar Lev <shahar@wizery.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 8, 2011 at 21:45, Luciano Coelho <coelho@ti.com> wrote:
>
> But what I meant with "the bug" was that, if this can be avoided in
> mac80211, why not do it there? Is it a a big effort to do it in
> mac80211?

Not sure it's a big effort, but it requires testing etc. I'm afraid
we're all pretty busy with other stuff right now :)

Arik
