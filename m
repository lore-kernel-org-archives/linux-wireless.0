Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr6.hinet.net ([168.95.4.106]:33891 "EHLO msr6.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab1GLCCv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 22:02:51 -0400
Date: Tue, 12 Jul 2011 10:00:49 +0800
From: Ali Bahar <ali@internetdog.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, WLAN FAE <wlanfae@realtek.com>
Subject: Re: [PATCH 0/2] staging: r8712u: Set ESSID/AP now possible before
 interface is brought Up.
Message-ID: <20110712020049.GA6364@internetdog.org> (sfid-20110712_040300_884634_A09CAA5F)
Reply-To: ali@internetdog.org
References: <1310378876-1311-1-git-send-email-ali@internetDog.org>
 <4E1B1D60.9030509@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E1B1D60.9030509@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 11, 2011 at 10:57:20AM -0500, Larry Finger wrote:
> On 07/11/2011 05:07 AM, Ali Bahar wrote:
> >These are updates to how the 'bup' flag is handled. The first allows Sets
> >before the interface is brought Up, and the second is housekeeping of the
> >flag's value when the interface is taken Down.
> >
> >Ali Bahar (2):
> >   staging: r8712u: Sets to SSID, and to AP MAC#, can now be done
> >     when the interface is Down.
> >   staging: r8712u: Interface-state not fully tracked.
> >
> >  drivers/staging/rtl8712/drv_types.h           |    5 +++++
> >  drivers/staging/rtl8712/os_intfs.c            |   14 ++++++++++++++
> >  drivers/staging/rtl8712/rtl871x_ioctl_linux.c |   25 +++++++++++++++++++++----
> >  3 files changed, 40 insertions(+), 4 deletions(-)
> >
> 
> Ali,
> 
> The patches look good, except for one problem. As this driver is in
> staging, the patches need to be sent to Greg Kroah-Hartman
> <gregkh@suse.de>, not through linux-wireless.

Hmm, I must admit that I'd raised this question with myself (ie
Staging's recipients), and had dug into it a bit, but neglected it at
the last minute. Sorry.

See below, anyway.

 
> One other point - for those patches that are properly sent through
> wireless, John Linville should be the one to receive those. He is
> the maintainer for that section, just as GregKH is the maintainer
> for staging.

Yes, but my understanding was that _you_ are my upstream, since you
are this driver's maintainer. (MAINTAINERS does not mention you for
exactly the r8712u, but does so for related devices.) So it was going
to be To: Larry, CC: wireless ML. Observing other threads suggested
that you may then Ack and send it to Linville -- which, now that you
have reminded me, would have been Greg KH.

OK, so I will re-send these to Greg. Do you not get even a CC?!! You
mention none, above, and had offered/expected to review them (in a 3
July email.)

(NB I ruled out a CC to linuxdriverproject.org, of course.)


thanks,
ali
