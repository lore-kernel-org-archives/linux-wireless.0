Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:46332 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbYIVVcA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 17:32:00 -0400
From: Chr <chunkeey@web.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: prism54 stopped working after upgrade from kernel 2.6.25.14-69.fc8 to 2.6.26.3-14.fc8
Date: Mon, 22 Sep 2008 23:32:00 +0200
Cc: Philippe Waroquiers <philippe.waroquiers@skynet.be>,
	linux-wireless@vger.kernel.org
References: <CB9B2237C21D46F3B852E45F75E91C52@soleil> <200809222205.28754.chunkeey@web.de> <1221944909.11865.9.camel@localhost.localdomain>
In-Reply-To: <1221944909.11865.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809222332.00500.chunkeey@web.de> (sfid-20080922_233205_682002_93495589)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 20 September 2008 23:08:29 Dan Williams wrote:
> On Mon, 2008-09-22 at 22:05 +0200, Chr wrote:
> > On Monday 22 September 2008 20:38:04 Philippe Waroquiers wrote:
> > > With the new kernel 2.6.26.3-14.fc8, I see that the prism54 card looks
> > > in a correct working mode (e.g. /sbin/iwlist wlan0 scan shows good scan
> > > results).
> > > But after that, wpa_supplicant cannot associate (gets a timeout)
> > > (while it works ok with 2.6.25.14-69.fc8)
> > > I have put below the output of wpa_supplicant for the bad case
> > > and for the good case.
> > >
> > > What can I do to further see what is going wrong ?
> >
> > Well, you can blame the fedora people if you want.
> >
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit
> >;h=aaa1553512b9105699113ea7e2ea726f3d9d4de2
>
> Is that commit not in stable 2.6.26 yet or something?
Hmm, no? AFAIK The mac80211 multiqueue changes went in somewhere in the 
2.6.27-rc cycle. so 2.6.26.stable doesn't need any extra patches, right?

Regards,
	Chr
