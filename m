Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59429 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab2AGWBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jan 2012 17:01:00 -0500
Date: Sat, 7 Jan 2012 16:47:48 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
	linux-wireless@vger.kernel.org
Subject: Re: suggestion for a reasonable value for
 /sys/module/iwlwifi/parameters/debug
Message-ID: <20120107214748.GB7746@tuxdriver.com> (sfid-20120107_230127_786702_AB60865B)
References: <201201071127.06717.toralf.foerster@gmx.de>
 <CANUX_P22vWv+XenOLs7Smf2P7CpPCVperF5JagS2JyCCpHXKOQ@mail.gmail.com>
 <CANUX_P2uzZwpCTcfgAu09PAcE-uUDCW0FMQK77P32cjwS2Hy9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P2uzZwpCTcfgAu09PAcE-uUDCW0FMQK77P32cjwS2Hy9Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 07, 2012 at 11:04:11PM +0200, Emmanuel Grumbach wrote:
> On Sat, Jan 7, 2012 at 22:55, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> >> If I choosed 0x43ff my syslog message files exploded - and I'd like to trouble
> >> shoot a problem with my wlan at a ThinkPad T400 (iwlwifi, 5100 AGN controler).
> >> The symptoms are that 1-2 times in a hour the network stops working without
> >> any message in /var/log/messages (kernel 3.0.x, 3.1.x, 3.2.0 tested).
> >>
> >> Thanks for any advice
> >> --
> >
> > For this kind of issues I added the TX_QUEUES debug flags, but I just
> > checked and it is not in 3.2. It is in John's wireless tree though. It
> > is bit 31: debug=0x80000000
> >
> > BTW - John, I have tried many times to understand all this, but stupid
> > me, couldn't ever make it. How come a patch is in wireless which in my
> > understanding (probably wrong) is supposed to feed the current rc
> > cycle (meaning the 3.2-rcX which just ended) and not be in 3.2 stable
> > release ? Sorry for the ignorance...
> >
> Or maybe the wireless tree has already be recreated on top of Linus's
> tree (through Dave's tree) after he merged everything ?

Right, that. :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
