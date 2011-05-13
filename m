Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758600Ab1EMMj2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 08:39:28 -0400
Date: Fri, 13 May 2011 14:39:13 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jorge Miguel <jmiggal@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Setting my WiFi adhoc connection in power save mode
Message-ID: <20110513123913.GD5516@redhat.com> (sfid-20110513_143932_475023_6D18CF2E)
References: <BANLkTi=pupNh=LMO-OEK+BbfNkpJz0nUkw@mail.gmail.com>
 <20110513115030.GB5516@redhat.com>
 <1305287703.3487.16.camel@jlt3.sipsolutions.net>
 <20110513122235.GC5516@redhat.com>
 <1305289642.3487.18.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1305289642.3487.18.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 13, 2011 at 02:27:22PM +0200, Johannes Berg wrote:
> > > Deliberate. On some platforms/systems, the way the device goes to sleep
> > > caused DMA trouble or something like that, and the ucode would sysassert
> > > when it tried to wake itself up. The problem was fairly rare, but of
> > > course the device wakes up 10 times a second or so ...
> > 
> > It's interesting if PS on 3945 ever works or was broken from very
> > beginning. I bet it was, on some old kernel, and this issue is similar
> > case like most of other bugs we have in iwlwifi - something that worked
> > well was broken by adding new chipsets/features support, but never fixed
> > again and just masked/disabled instead.
> 
> I doubt it, iirc it was just some DMA issue that was discovered at some
> point and nobody could really pinpoint it. Those old devices stored some
> internal data into a host memory buffer, and reading them back sometimes
> corrupted them.

Ok, so I will probably not try to reenable PS (as long someone clearly
state that it works in the past, and this is a regression).

Does this problem happen on both 4965 and 3945 ?

Stanislaw
