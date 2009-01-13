Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:3596 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbZAMMB0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 07:01:26 -0500
Received: by yw-out-2324.google.com with SMTP id 9so3607122ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 04:01:25 -0800 (PST)
Message-ID: <496C8292.8060001@gmail.com> (sfid-20090113_130130_313157_3B14EB05)
Date: Tue, 13 Jan 2009 04:01:22 -0800
From: Jason Newton <nevion@gmail.com>
MIME-Version: 1.0
To: Rami Rosen <roszenrami@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: 802.11n status (iwlagn)
References: <496C3F37.4030808@gmail.com> <b25312890901130241l635ffe78na10d2aa468365e7e@mail.gmail.com>
In-Reply-To: <b25312890901130241l635ffe78na10d2aa468365e7e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> In http://www.linuxwireless.org/en/users/Drivers, there
> is a table of drivers; some of them do support 802.11n,
> as you can see form the PHY modes column
> (there might be more such drivers, take into account that this table
> might not be always up to date).
> 
>  Intel iwl4965 is among them;  I did not perform any tests with
> 4965-based iwlagn devices with 80211.n though.

So if n (or n-draft) support really is in the 4965 driver already - how
do I access it?  It doesn't seem to be happening automatically -
filetransfers/iptraf let me know that much.  Very confused about what's
going on here and if I need any iwconfig magic or something like
replacing pfifo with multiq for device qdisc.  I haven't a clue.

> - I believe that you are aware that the 80211.n spec is expected
> only at the end of 2009 (December 2009) or later.

Ah, true, but I guess I was also wondering about n draft support since
these devices are available now and have been for quite a while.  I can
get 100 mbit/s or so with my 4965 card in windows with intel's drivers
and my asus wl500w router.  But only a lousy 54 or so in linux.  That
just ain't right.
