Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34510 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab2HXXyf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 19:54:35 -0400
Received: by ialo24 with SMTP id o24so4453026ial.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Aug 2012 16:54:35 -0700 (PDT)
Message-ID: <50381437.7040903@lwfinger.net> (sfid-20120825_015455_105311_9B603245)
Date: Fri, 24 Aug 2012 18:54:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Patrick Connolly <pjc999@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Question about ath9k/mac80211 Driver
References: <CAE3CJbkhmZ75gBjEToshQ2M9Xu7ciVrDtv8n2DVZepnhBoNt-Q@mail.gmail.com> <50365AC8.7030503@lwfinger.net> <CAE3CJbm5a0hZ8uWT8yU5Z8vbKX2HNwZ2uPUFULGA-3no1XFc_Q@mail.gmail.com> <5036660B.9020208@lwfinger.net> <CAE3CJbkodiw7kZ9F1PQrzZA2hSCF2PAwPAw-UHMwKhC2-6Ky2g@mail.gmail.com>
In-Reply-To: <CAE3CJbkodiw7kZ9F1PQrzZA2hSCF2PAwPAw-UHMwKhC2-6Ky2g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/24/2012 06:38 PM, Patrick Connolly wrote:
> Okay so I built "iw" version 0.9.22 successfully (after much grief).
> The help page shows that "set bitrates" is now supported:
>
>          dev <devname> set bitrates [legacy-<2.4|5> <legacy rate in Mbps>*]
>
>
>   but when I try to use it I get:
>
>         # iw dev wlan0 set bitrates legacy-2.4 1 2 5.5 11
>         command failed: Operation not supported (-95)
>
> ...so what does this mean?  Is it "iw" or the driver that lacks the support?

I would think that your kernel is too old. What version are you running?

Larry


