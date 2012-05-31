Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34505 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab2EaLPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 07:15:49 -0400
Message-ID: <1338462946.9102.1.camel@jlt3.sipsolutions.net> (sfid-20120531_131553_206436_686BF185)
Subject: Re: iwlwifi: GF was set with SGI:SISO
From: Johannes Berg <johannes@sipsolutions.net>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Date: Thu, 31 May 2012 13:15:46 +0200
In-Reply-To: <4FC74B3C.1090501@cesarb.net>
References: <4FC17BA8.2050606@cesarb.net>
	  (sfid-20120527_030308_122290_604E4002) <1338450650.4531.6.camel@jlt3.sipsolutions.net>
	 <4FC74B3C.1090501@cesarb.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-31 at 07:43 -0300, Cesar Eduardo Barros wrote:
> Em 31-05-2012 04:50, Johannes Berg escreveu:
> > On Sat, 2012-05-26 at 21:56 -0300, Cesar Eduardo Barros wrote:
> >> I have twice now seen a problem with iwlwifi where rate control gets
> >> "stuck" (the tx bitrate as shown by "iw dev wlan0 link" does not change
> >> anymore), while spamming the kernel log with "iwlwifi 0000:03:00.0: GF
> >> was set with SGI:SISO".
> >>
> >> What I believe is happening is the following scenario:
> > [...]
> >
> > Unfortunately, I don't have any idea right away right now what's going
> > on. Would you file a bug on bugzilla.intellinuxwireless.org so we can
> > track it and help you better? We may want to reproduce it and/or ask you
> > to collect some tracing information and it's easier to collect all that
> > in a bug report.
> 
> Filed as http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2361.

Thanks, I'll follow up there.

johannes

