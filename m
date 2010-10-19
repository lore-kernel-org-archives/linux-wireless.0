Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:55743 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755809Ab0JSAqn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Oct 2010 20:46:43 -0400
Date: Mon, 18 Oct 2010 17:30:00 -0700
From: Greg KH <gregkh@suse.de>
To: Rafa?? Mi??ecki <zajec5@gmail.com>
Cc: Henry Ptasinski <henryp@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>, linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: Request for free-distributable Broadcom's (G|LP)-PHY firmware
Message-ID: <20101019003000.GA28348@suse.de>
References: <AANLkTik45KLdLf5UpjPtXTNgy4Df_BupyQ3SzRr6gZgC@mail.gmail.com> <AANLkTin_JcEyT21dTS=Ew868HJvZQ2FVZBGXjCZn=8O_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTin_JcEyT21dTS=Ew868HJvZQ2FVZBGXjCZn=8O_@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 19, 2010 at 02:02:06AM +0200, Rafa?? Mi??ecki wrote:
> W dniu 9 pa??dziernika 2010 00:07 u??ytkownik Rafa?? Mi??ecki
> <zajec5@gmail.com> napisa??:
> > Hi Broadcom fellows!
> >
> > It's great that afters long years of... well, pretty horrible
> > relations with Linux/opensource you have taken actions to change your
> > image. I guess brcm80211 it's perfect yet, and people may like it more
> > or less, but it's no doubt you made step in the right direction.
> > Thanks for that!
> >
> > As you should know, you released driver and firmware for 802.11n
> > devices only. I believe it was right, as these device seem to be the
> > most nowadays and were the only ones without any open source support.
> > For older devices: G-PHY and LP-PHY we have working b43 driver that is
> > in relatively good shape. However... there is one thing we still miss
> > for olders cards.
> >
> > Every time someone wants to use b43 it's necessary to download quite
> > big package from openwrt, unpack it, extract firmware and install it.
> > That simply happens because we don't have just-firmware files with
> > nice licensing. And of course there goes my request:
> >
> > *Can you submit G-PHY and LP-PHY firmware to linux-firmware using some
> > normal licensing, please?*
> >
> > This is of course not the best I could wish for, but is important
> > anyway and it should be easy decision. Ideally you could release
> > sources of firmware (plus toolchain eventualy... however, we have nice
> > toolchain from Michael), but I guess it would need more time and
> > decisions to make it happen. So as for now I guess we would be happy
> > with just closed source but easy-distributable firmware. Could you
> > release, submit it?
> 
> Greg: I didn't receive any answer from Broadcom for any mail. Do you
> maybe have any "working" contact with this company? :|

Heh, no, Henry and the others on the cc: above are all I have.
Hopefully they will be able to reply, or at least give us a "we are not
the developers/people who can help out with this, but please try these
other email addresses..."

Henry?

thanks,

greg k-h
