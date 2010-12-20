Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41540 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933189Ab0LTVWW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 16:22:22 -0500
Received: by qyk12 with SMTP id 12so3672003qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 13:22:21 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20101220193003.GC10104@tuxdriver.com>
References: <20101220193003.GC10104@tuxdriver.com>
Date: Mon, 20 Dec 2010 22:22:21 +0100
Message-ID: <AANLkTik3+WXOvAWZjvNNO+JfQx2pK0bAYs5UOpr55eyB@mail.gmail.com>
Subject: Re: new stuff for 2.6.38 needs to be posted _now_
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 20, 2010 at 8:30 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> You may have noticed that Linus has released 2.6.37-rc6.  So, the
> merge window is around the corner!
>
> For those that need a reminder, the opening of the merge window is a
> _deadline_ for new features.  Once the merge window opens, only fixes
> will be accepted for 2.6.38.  In fact, any non-fix patches need to
> already be in wireless-next-2.6 when the merge window opens if you want
> them in 2.6.38.  That means you need to get them posted _now_, so they
> can be reviewed and I can find time to merge them before the deadline.
>
> You have been warned...this means you!
>
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Is it possible to give an overview of the current status of
linux-wireless development going into 2.6.38?
New features, bigger bugfixes, new drivers, etc.?
For the drivers part you could trigger the driver maintainer(s)?
Also, it would be nice to read from user-space news like
wpa_supplicant, iw, crda & wireless-regdb, etc. related to the changes
to linux-wireless (for example you should install iw in version XYZ to
have support for new features of your driver ABC).
I have seen cool overviews from David Miller for net-2.6, regularly
also from rcX to rcX+1.
This is also some sort of documenting the development in your sub-trees.

Personally, I am very interested in power-management topic (my
hardware is ath5k and iwl3945 currently), but I am planning to upgrade
to 802.11N (router and wlan device).

- Sedat -
