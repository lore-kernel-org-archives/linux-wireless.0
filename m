Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757150Ab3D2P7N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 11:59:13 -0400
Message-ID: <1367251268.20151.0.camel@dcbw.foobar.com> (sfid-20130429_175919_733666_9901936D)
Subject: Re: Intel Centrino Wireless-N 2230 (rev c4) bug
From: Dan Williams <dcbw@redhat.com>
To: Paolo Zaffino <p.zaffino@unicz.it>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, ilw@linux.intel.com
Date: Mon, 29 Apr 2013 11:01:08 -0500
In-Reply-To: <517C18A4.70402@unicz.it>
References: <517BD02A.5060904@unicz.it>
	  (sfid-20130427_151940_748350_F10D6AF1) <1367085173.8445.0.camel@jlt4.sipsolutions.net>
	 <517C18A4.70402@unicz.it>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-04-27 at 20:27 +0200, Paolo Zaffino wrote:
> First of all thanks for your support.
> Can you give me any advice on what look for in my system?
> I really haven't idea about this strange situation.

If you are using NetworkManager, also grab the NM log output which goes
to syslog's daemon facility.  That gets dumped to a file depending on
your distro, which could
be /var/log/messages, /var/log/daemon.log, /var/log/syslog, /var/log/NetworkManager.log, or systemd's journal.

Dan

> Thanks a lot.
> Paolo
> 
> 
> 
> On 27/04/2013 19:52, Johannes Berg wrote:
> > On Sat, 2013-04-27 at 15:18 +0200, Paolo Zaffino wrote:
> >
> >
> >> [ 1756.822019] wlp3s0: deauthenticating from 74:ea:3a:cd:28:42 by local
> >> choice (reason=3)
> > This is your problem, you're probably running two instances of
> > wpa_supplicant or something equally strange.
> >
> > johannes
> >
> >
> 
> 


