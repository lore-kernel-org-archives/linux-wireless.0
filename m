Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbYIVVJE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 17:09:04 -0400
Subject: Re: prism54 stopped working after upgrade from kernel
	2.6.25.14-69.fc8 to 2.6.26.3-14.fc8
From: Dan Williams <dcbw@redhat.com>
To: Chr <chunkeey@web.de>
Cc: Philippe Waroquiers <philippe.waroquiers@skynet.be>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200809222205.28754.chunkeey@web.de>
References: <CB9B2237C21D46F3B852E45F75E91C52@soleil>
	 <200809222205.28754.chunkeey@web.de>
Content-Type: text/plain
Date: Sat, 20 Sep 2008 17:08:29 -0400
Message-Id: <1221944909.11865.9.camel@localhost.localdomain> (sfid-20080922_230920_352065_55914BD6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-09-22 at 22:05 +0200, Chr wrote:
> On Monday 22 September 2008 20:38:04 Philippe Waroquiers wrote:
> > With the new kernel 2.6.26.3-14.fc8, I see that the prism54 card looks in a
> > correct working mode (e.g. /sbin/iwlist wlan0 scan shows good scan
> > results).
> > But after that, wpa_supplicant cannot associate (gets a timeout)
> > (while it works ok with 2.6.25.14-69.fc8)
> > I have put below the output of wpa_supplicant for the bad case
> > and for the good case.
> >
> > What can I do to further see what is going wrong ?
> >
> 
> Well, you can blame the fedora people if you want.
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=aaa1553512b9105699113ea7e2ea726f3d9d4de2

Is that commit not in stable 2.6.26 yet or something?

I also had to make sure that only one driver got bound to my card, both
p54 and prism54 fought for it.

Dan


