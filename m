Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out04.msg.oleane.net ([62.161.7.2]:42972 "EHLO
	smtp-out04.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbaJMH5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2014 03:57:39 -0400
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Michal Kazior'" <michal.kazior@tieto.com>
Cc: <ath10k@lists.infradead.org>,
	"'linux-wireless'" <linux-wireless@vger.kernel.org>
References: <773DB8A82AB6A046AE0195C68612A319018C2750@sbs2003.acksys.local> <CA+BoTQ=a8kY0CGGKHwRhk4cg=V0oimipuht6Pkc0K0x4WMMn-A@mail.gmail.com>
In-Reply-To: <CA+BoTQ=a8kY0CGGKHwRhk4cg=V0oimipuht6Pkc0K0x4WMMn-A@mail.gmail.com>
Subject: RE: ath10k firmware crash
Date: Mon, 13 Oct 2014 09:35:05 +0200
Message-ID: <023801cfe6b8$350c1930$9f244b90$@acksys.fr> (sfid-20141013_095742_876809_2AD71228)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Thanks for your reply,

> 
> Can you then provide a crash register dump for 10.1, please? I can't help you
> much with the 636 dump.
> 
Yes I can, but where I find it?

> Are you perhaps trying to run STA with 4addr bridging? If so then make sure
> you use recent ath10k as this was known to be a problem.
> 
Yes I'm testing with 4 addr bridging because I need to bridge this interface. I' ll try without this option.
I'm testing with commit number 38eeda3ae6f90fde5546bdd48ee4ff3090f238c0 from kernel.org/pub/scm/linux/kernel/git/firmare/linux-firmware. It is the latest version in openwrt. 

> Can you also provide ath10k traces or debug logs, please?
> 
I'll send a trace.
> 
> >         Is it possible to use at the same time on 2 different cards the AP
> mode and client mode?
> 
> Yes, it is possible.
> 
> 
> Michał

