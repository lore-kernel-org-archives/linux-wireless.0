Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp01.msg.oleane.net ([62.161.4.1]:37170 "EHLO
	smtp01.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbaJMOH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2014 10:07:58 -0400
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Michal Kazior'" <michal.kazior@tieto.com>
Cc: <ath10k@lists.infradead.org>,
	"'linux-wireless'" <linux-wireless@vger.kernel.org>
References: <773DB8A82AB6A046AE0195C68612A319018C2750@sbs2003.acksys.local>	<CA+BoTQ=a8kY0CGGKHwRhk4cg=V0oimipuht6Pkc0K0x4WMMn-A@mail.gmail.com>	<023801cfe6b8$350c1930$9f244b90$@acksys.fr>	<CA+BoTQkXc-VL1ixRK5KWUiE0igCxXRQyyde86TAvuKVxZhEPdg@mail.gmail.com>	<024901cfe6c6$e1905780$a4b10680$@acksys.fr> <CA+BoTQnQkDjkMMu5x-c69s1THf7SQfet2vsOPWs++PtyEHEeTw@mail.gmail.com>
In-Reply-To: <CA+BoTQnQkDjkMMu5x-c69s1THf7SQfet2vsOPWs++PtyEHEeTw@mail.gmail.com>
Subject: RE: ath10k firmware crash
Date: Mon, 13 Oct 2014 16:06:50 +0200
Message-ID: <025c01cfe6ee$efed3960$cfc7ac20$@acksys.fr> (sfid-20141013_160811_438759_85167E16)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >>
> >> >> Are you perhaps trying to run STA with 4addr bridging? If so then
> >> >> make sure you use recent ath10k as this was known to be a problem.
> >> >>
> >> > Yes I'm testing with 4 addr bridging because I need to bridge this
> >> interface. I' ll try without this option.
> >> > I'm testing with commit number
> >> > 38eeda3ae6f90fde5546bdd48ee4ff3090f238c0
> >> from kernel.org/pub/scm/linux/kernel/git/firmare/linux-firmware. It
> >> is the latest version in openwrt.
> >> >
> >> >> Can you also provide ath10k traces or debug logs, please?
> >> >>
> >> > I'll send a trace.
> >>
> > I'm using the compat wireless from Openwrt.
> >         Compat wireless version 2014-05-22, but we updated the
> > firmware with the latest version provided by openwrt (commit number
> > 38eeda3ae6f90fde5546bdd48ee4ff3090f238c0 from
> > kernel.org/pub/scm/linux/kernel/git/firmare/linux-firmware)
> 
> The fix for 4addr STA bridging is in the driver, not the firmware.
> 
> The compat version you're using doesn't contain the required fix. I'm pretty
> sure openwrt compat 2014-09-26 contains it.
It fix my issue. Thanks for your help.

Cedric Voncken
> 
> 
> Michał
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

