Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp26.msg.oleane.net ([62.161.4.26]:50889 "EHLO
	smtp26.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbaJMJVZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2014 05:21:25 -0400
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Michal Kazior'" <michal.kazior@tieto.com>
Cc: <ath10k@lists.infradead.org>,
	"'linux-wireless'" <linux-wireless@vger.kernel.org>
References: <773DB8A82AB6A046AE0195C68612A319018C2750@sbs2003.acksys.local>	<CA+BoTQ=a8kY0CGGKHwRhk4cg=V0oimipuht6Pkc0K0x4WMMn-A@mail.gmail.com>	<023801cfe6b8$350c1930$9f244b90$@acksys.fr> <CA+BoTQkXc-VL1ixRK5KWUiE0igCxXRQyyde86TAvuKVxZhEPdg@mail.gmail.com>
In-Reply-To: <CA+BoTQkXc-VL1ixRK5KWUiE0igCxXRQyyde86TAvuKVxZhEPdg@mail.gmail.com>
Subject: RE: ath10k firmware crash
Date: Mon, 13 Oct 2014 11:20:07 +0200
Message-ID: <024901cfe6c6$e1905780$a4b10680$@acksys.fr> (sfid-20141013_112136_959265_78BA7F58)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Message d'origine-----
> De : Michal Kazior [mailto:michal.kazior@tieto.com]
> Envoyé : lundi 13 octobre 2014 09:54
> À : voncken
> Cc : ath10k@lists.infradead.org; linux-wireless
> Objet : Re: ath10k firmware crash
> 
> On 13 October 2014 09:35, voncken <cedric.voncken@acksys.fr> wrote:
> >         Thanks for your reply,
> >
> >>
> >> Can you then provide a crash register dump for 10.1, please? I can't
> >> help you much with the 636 dump.
> >>
> > Yes I can, but where I find it?
> 
> https://github.com/kvalo/ath10k-firmware/blob/master/10.1/firmware-
> 2.bin_10.1.467.2-1
> 
> 
> >> Are you perhaps trying to run STA with 4addr bridging? If so then
> >> make sure you use recent ath10k as this was known to be a problem.
> >>
> > Yes I'm testing with 4 addr bridging because I need to bridge this
> interface. I' ll try without this option.
> > I'm testing with commit number 38eeda3ae6f90fde5546bdd48ee4ff3090f238c0
> from kernel.org/pub/scm/linux/kernel/git/firmare/linux-firmware. It is the
> latest version in openwrt.
> >
> >> Can you also provide ath10k traces or debug logs, please?
> >>
> > I'll send a trace.
> 
I'm using the compat wireless from Openwrt.
	Compat wireless version 2014-05-22, but we updated the firmware with the latest version provided by openwrt (commit number 38eeda3ae6f90fde5546bdd48ee4ff3090f238c0 from kernel.org/pub/scm/linux/kernel/git/firmare/linux-firmware)

> Thanks.
> 
> By the way, what kernel/compat-wireless are you using? I'm suspecting your
> build might be missing the fix for STA bridging.
Thanks.

> 
> 
> Michał

