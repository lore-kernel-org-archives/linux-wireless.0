Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f178.google.com ([209.85.218.178]:62389 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602AbZCBXii (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 18:38:38 -0500
Received: by bwz26 with SMTP id 26so2161464bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2009 15:38:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49AC520E.6040101@inrialpes.fr>
References: <49AC520E.6040101@inrialpes.fr>
Date: Mon, 2 Mar 2009 23:38:35 +0000
Message-ID: <3ace41890903021538s3fab479ei3a5eaa2c4bc47b85@mail.gmail.com> (sfid-20090303_003857_441357_20E9845A)
Subject: Re: rtl8187 bugreport
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Mate Soos <soos@inrialpes.fr>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 2, 2009 at 9:39 PM, Mate Soos <soos@inrialpes.fr> wrote:
> Hi!
>
> I have an rtl8187, the variant that shows:
>
> Bus 007 Device 003: ID 0bda:8197 Realtek Semiconductor Corp. RTL8187B
> Wireless Adapter
>
> with lsusb. I use Ubuntu Intrepid, kernel
>
> Linux satellite 2.6.27-11-generic #1 SMP Thu Jan 29 19:24:39 UTC 2009
> i686 GNU/Linux
>
> the latest drivers from
>
> compat-wireless-2009-02-25
>
> installed, working (the driver that comes with the kernel doesn't
> suspend, ever). It works quite well(yes, I also have signal issues,
> etc.), but I just suspended a moment ago, and I got a nice kernel panic.
> I am sure this is due to the rtl8187, as it is meant to be experimental
> (since it's a B variant). As a side-note, this is not the first time I
> got a panic due to this driver, and all the time the panic's message
> either contained something to do with 80211 or with the rtl8187. The
> panic's screenshot is attached.
>
> I hope this info helps someone get this driver more stable :)
>
> Bests,
>
> Mate
>
> PS: The computer is a Toshiba Satellite laptop, with integrated rtl8187
>

It is  known issue - there are some work-arounds, and work-in-progress patches:

http://bugzilla.kernel.org/show_bug.cgi?id=11887
