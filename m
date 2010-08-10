Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50730 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757936Ab0HJVjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 17:39:45 -0400
Received: by eya25 with SMTP id 25so4106809eya.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Aug 2010 14:39:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTim4_HoHwdhGqAZqcGf2oq7boktdZFW4-w5DpdDa@mail.gmail.com>
References: <AANLkTim4_HoHwdhGqAZqcGf2oq7boktdZFW4-w5DpdDa@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 10 Aug 2010 17:39:24 -0400
Message-ID: <AANLkTinuYOvwNZAFgq67f4XBL4YQ+b2z4EBMcmvbMYi3@mail.gmail.com>
Subject: [WTF, maintainers] Re: *PING* iwlagn 2.6.35: "BA scd_flow 0 does not
	match txq_id 10" regression
To: linux-wireless@vger.kernel.org, wey-yi.w.guy@intel.com
Cc: linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 26, 2010 at 4:02 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> There's a regression in 2.6.35 where the connection breaks and iwlagn
> writes a bunch of:
>
> iwlagn 0000:03:00.0: BA scd_flow 0 does not match txq_id 10
>
> This is confirmed [1] and a patch supposedly exists.  Since this
> breaks at least two people's wireless and 2.6.35 is about to be
> released, can we see the patches?
>
> Thanks,
> Andy
>
> [1] http://article.gmane.org/gmane.linux.kernel.wireless.general/53552
>

This regression was reported on July 21 and confirmed, supposedly with
a patch available, on July 24 (or maybe July 23).  On July 26 I pinged
the list because I'm affected as well.

It's now August 10 and both 2.6.35 and 2.5.35.1 have been released and
the bug is still there.  WTF happened?  (I admit I haven't actually
tested 2.6.35.1 because it's still compiling, but I see nothing to
suggest that it's been fixed.)

Thanks,
Andy

P.S.  iwlagn malfunctions for me *all the time*.  I'd love to help
debug but it's hard when no one pays attention and when the bugs are
all hard to trigger.  Any volunteers to help?
