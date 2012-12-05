Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:51515 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab2LEVDl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 16:03:41 -0500
Message-ID: <1354741378.6234.88.camel@cumari.coelho.fi> (sfid-20121205_220344_785382_7BCF6041)
Subject: Re: [PATCH 05/20] wlcore: increase scan dwell times if no activity
From: Luciano Coelho <coelho@ti.com>
To: Eyal Shapira <eyal@wizery.com>
CC: Arik Nemtsov <arik@wizery.com>, <linux-wireless@vger.kernel.org>
Date: Wed, 5 Dec 2012 23:02:58 +0200
In-Reply-To: <CAF8O4-xizhg8T4eQ13BGLR=ZDYz95+6zEWjW8HchW7CfUrfQMQ@mail.gmail.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
	 <1354095769-8724-6-git-send-email-arik@wizery.com>
	 <1354706476.6234.50.camel@cumari.coelho.fi>
	 <CAF8O4-xizhg8T4eQ13BGLR=ZDYz95+6zEWjW8HchW7CfUrfQMQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-05 at 14:19 +0200, Eyal Shapira wrote:
> On 5 December 2012 13:21, Luciano Coelho <coelho@ti.com> wrote:
> >
> >
> > IMO it would have been nicer to keep the existing ones as they are and
> > not change the semantics.  Then add the new ones with another name.
> > Maybe something like "max_dwell_time_active_long", which is more
> > generic.
> >
> > It is possible that we will find more scenarios where this long scans
> > could be used (eg. if it would be possible to identify whether there are
> > any low latency TIDs running or not).
> >
> 
> Sure. I'll respin it.

BTW, please take Arik's v2 which was sent to the list on Nov 30th before
you make your updates.  It has a mac80211 API change taken into account.

--
Luca.

