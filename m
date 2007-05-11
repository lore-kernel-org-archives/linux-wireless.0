Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2718 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756218AbXEKAcp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 20:32:45 -0400
Date: Thu, 10 May 2007 20:12:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>, jketreno <jketreno@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: Specifing rate control algorithm?
Message-ID: <20070511001212.GB6971@tuxdriver.com>
References: <464253CE.2030504@linux.intel.com> <20070510132756.2ca660a0@midnight.suse.cz> <46434596.6010908@linux.intel.com> <20070510194233.335004b7@griffin.suse.cz> <46437DC8.2060805@linux.intel.com> <20070510212355.6c13cde8@griffin.suse.cz> <1ba2fa240705101524x2676a09eyeff3b71ed2542478@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240705101524x2676a09eyeff3b71ed2542478@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 11, 2007 at 01:24:58AM +0300, Tomas Winkler wrote:
> On 5/10/07, Jiri Benc <jbenc@suse.cz> wrote:
> >On Thu, 10 May 2007 13:17:12 -0700, jketreno wrote:

> >> Generic algorithms aren't as capable as hardware specific algorithms
> >> when you factor performance, latency, system utilization, power
> >> consumption, etc.  Optimal algorithms are written to take advantage of
> >> the capabilities exposed by the hardware.
> >
> >You said the same about hardware scanning. Michael showed you that's
> >not true.
> >
> Michael has shortened the dwell time on the channel, while hw scanning
> has shorten switching time from the channel to channel and no the time
> you are listening on the channel
> I wouldn't call it an optimization. Did he measured the power consumption ?

This was going to be my question, and I think it is a worthy point. :-)

John

> >If the slowdown is not big, yes, it is. Unifying things almost always
> >means you need to accept some trade-offs.
> 
> Clean API gives you the ability to enjoy from the both worlds. WiFi is
> about mobility power saving and therefore hw offloading is essential.
> What worth the few more lines of the code that gives you this ability
> this is also a trade-off.

Agreed.  FWIW, power saving is worthwhile even for fixed stations as well.

John
-- 
John W. Linville
linville@tuxdriver.com
