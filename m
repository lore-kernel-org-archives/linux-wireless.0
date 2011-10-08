Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:52736 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750972Ab1JHUCu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Oct 2011 16:02:50 -0400
Received: by mail-bw0-f42.google.com with SMTP id c12so4512405bkb.1
        for <linux-wireless@vger.kernel.org>; Sat, 08 Oct 2011 13:02:48 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: remove warning message during IBSS Tx
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <anamtsov@gmail.com>
Cc: Shahar Lev <shahar@wizery.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <CA+XVXff_5isgfReUYXh8K1nNTtAqnFp5tb36EKLL7MBaTka+UQ@mail.gmail.com>
References: <1318004245-18347-1-git-send-email-shahar@wizery.com>
	 <1318004434.3988.16.camel@jlt3.sipsolutions.net>
	 <CANCvt+6JkxnE6Z7soUuhQSbzpxuxYUNC7z0vv+jn-sH+jpY4Qg@mail.gmail.com>
	 <1318022253.3549.108.camel@cumari>
	 <CA+XVXfd+vN7b=oYrysPCuynAgy5=4SgRHuznJRW0h+6ez7YqsQ@mail.gmail.com>
	 <1318103127.9690.46.camel@cumari>
	 <CA+XVXff_5isgfReUYXh8K1nNTtAqnFp5tb36EKLL7MBaTka+UQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 08 Oct 2011 23:02:40 +0300
Message-ID: <1318104160.9690.49.camel@cumari> (sfid-20111008_220253_524570_B53E257F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-10-08 at 21:55 +0200, Arik Nemtsov wrote: 
> On Sat, Oct 8, 2011 at 21:45, Luciano Coelho <coelho@ti.com> wrote:
> >
> > But what I meant with "the bug" was that, if this can be avoided in
> > mac80211, why not do it there? Is it a a big effort to do it in
> > mac80211?
> 
> Not sure it's a big effort, but it requires testing etc. I'm afraid
> we're all pretty busy with other stuff right now :)

Not a very good excuse when it comes to upstreaming, but okay, I'll take
this in anyway. :)

Thanks, Shahar, and welcome! :)

(BTW, Shahar Lev is not to be confused with Shahar Levi, as they are two
different persons :)

-- 
Cheers,
Luca.

