Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:24535 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673AbZDLJWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Apr 2009 05:22:20 -0400
Received: by fg-out-1718.google.com with SMTP id 16so226472fgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 12 Apr 2009 02:22:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49E17FB4.4050807@lwfinger.net>
References: <49dd785f.mp1oc4nY+m3n0uHL%Larry.Finger@lwfinger.net>
	 <3ace41890904091453o158f5c00ldad58da3d002180e@mail.gmail.com>
	 <49DE7E42.5020700@lwfinger.net>
	 <3ace41890904102123o3e280edau933c8235649879c5@mail.gmail.com>
	 <3ace41890904102129n2b62001clff35027088bedcd1@mail.gmail.com>
	 <49E0C713.4040507@lwfinger.net>
	 <3ace41890904112157r2037946xddd8fca9222fd97e@mail.gmail.com>
	 <49E17FB4.4050807@lwfinger.net>
Date: Sun, 12 Apr 2009 10:22:18 +0100
Message-ID: <3ace41890904120222u151becb7pe2cb07a816a51d73@mail.gmail.com> (sfid-20090412_112225_085306_4EB60169)
Subject: Re: [RFT/RFC] rtl8187: Implement TX/RX blink for LED
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 12, 2009 at 6:44 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> It is not user configurable. The revised Kconfig selects it automatically if
> MAC80211_LEDS is set and LEDS_CLASS is y or m. The user never sees it in the
> configuration process.

That's great and that's how I think it should work.

> Thanks for the heads up. I have not been able to suspend my computer due to
> other problems, but I'll see what I can find.

My guess is that it is probably related to resource to do with the new
work-queue.

> On another subject, I have been working with the vendor driver from
> rtl8187B_linux_26.1036.0708.2008. I stripped out a lot of the dead code and made
> the modifications so that it compiles cleanly with kernel 2.6.30-rc1. I also
> modified it to handle my RTL8187B stick with the 8187 ID. The driver scans OK,
> but so far it has not associated with my WPA2 AP. My hope is to get it running
> so that I can compare throughput with the current Linux driver.

That's quite some work! I wouldn't mind seeing the diff, or even the
incremental diffs, if you have done it in git.
I had an old patch for beyond 2.6.28 but never got it to work, I
think. Have some problem with porting forward another vendor driver
(the zd1211) and can certainly benefit from some tips.
