Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50069 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759220Ab1EMMpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 08:45:54 -0400
Subject: Re: Setting my WiFi adhoc connection in power save mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Jorge Miguel <jmiggal@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20110513123913.GD5516@redhat.com>
References: <BANLkTi=pupNh=LMO-OEK+BbfNkpJz0nUkw@mail.gmail.com>
	 <20110513115030.GB5516@redhat.com>
	 <1305287703.3487.16.camel@jlt3.sipsolutions.net>
	 <20110513122235.GC5516@redhat.com>
	 <1305289642.3487.18.camel@jlt3.sipsolutions.net>
	 <20110513123913.GD5516@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 14:45:51 +0200
Message-ID: <1305290751.3487.33.camel@jlt3.sipsolutions.net> (sfid-20110513_144602_678884_985D47DF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-13 at 14:39 +0200, Stanislaw Gruszka wrote:

> > I doubt it, iirc it was just some DMA issue that was discovered at some
> > point and nobody could really pinpoint it. Those old devices stored some
> > internal data into a host memory buffer, and reading them back sometimes
> > corrupted them.
> 
> Ok, so I will probably not try to reenable PS (as long someone clearly
> state that it works in the past, and this is a regression).

Well, problem is that it _did_ work for some people, since it seemed to
depend on the platform. I don't remember all the details though.

> Does this problem happen on both 4965 and 3945 ?

I'm not sure on 3945. ISTR there was an issue, but I don't know if it
was the same one.

johannes

