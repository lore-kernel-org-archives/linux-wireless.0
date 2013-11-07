Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab3KGWZ2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Nov 2013 17:25:28 -0500
Message-ID: <1383863100.2391.5.camel@dcbw.foobar.com> (sfid-20131107_232532_239348_91D670BC)
Subject: Re: future of prism2_usb (aka wlan-ng) in staging tree
From: Dan Williams <dcbw@redhat.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org
Date: Thu, 07 Nov 2013 16:25:00 -0600
In-Reply-To: <20131107194641.GE12612@shaftnet.org>
References: <20131107160522.GA12612@shaftnet.org>
	 <527BC04F.2080000@lwfinger.net> <20131107163719.GC12612@shaftnet.org>
	 <20131107175201.GA2002@tuxdriver.com> <20131107185714.GD12612@shaftnet.org>
	 <20131107191122.GD2002@tuxdriver.com> <20131107194641.GE12612@shaftnet.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-11-07 at 14:46 -0500, Solomon Peachy wrote:
> On Thu, Nov 07, 2013 at 02:11:23PM -0500, John W. Linville wrote:
> > And all of which were nominated by someone (possibly me) to be shuffled
> > out of the tree due to lack of users and unknown functional status...
> 
> Heh, fair enough!
> 
> > I don't want to discourage anyone from working on something that
> > scratches their itch, especially if you have working hardware and
> > some users.  OTOH, I'd rather not add a long term support burden to
> > the kernel if nobody is going to use it...?
> 
> On an average month the linux-wlan-ng repository I still host gets 3-4K 
> non-spider hits for the USB firmware files, so in this particular case 
> there are still users out there.
> 
> At this point it's a more modern driver than the ones already in the 
> kernel, and I'm willing to maintain it if there's a point to doing so.

What's the delta in device support between prism2_usb and the hostap
driver's USB subdriver?  Is there any overlap?

Dan

