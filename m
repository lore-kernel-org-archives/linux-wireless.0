Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:38903 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbZCaR5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 13:57:43 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [ipw3945-devel] 2.6.29-wl-36116-g6a982a0: connection loss
Date: Tue, 31 Mar 2009 19:57:39 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	reinette chatre <reinette.chatre@intel.com>,
	Nico -telmich- Schottelius
	<nico-linux-ipw3945-devel@schottelius.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <20090331044946.GA10616@denkbrett.schottelius.org> <1238520041.5970.112.camel@johannes.local> <8763hpsi0a.fsf@litku.valot.fi>
In-Reply-To: <8763hpsi0a.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903311957.39264.chunkeey@web.de> (sfid-20090331_195747_525536_8B15309C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 31 March 2009 19:45:57 Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> >> Perhaps the new beacon filtering work [1] is changing more than it
> >> intended?
> >
> > I think it only changed the messages here. Previously, that message
> > simply wouldn't have been there, instead you'd only have seen the "No
> > ProbeResp from current AP - assume out of range" thing.
> 
> At least I have been using latest wireless-testing with iwl3945 all the time
> (for example right now) and I haven't noticed any problems.
> 
> But your comment makes me think is the "beacon loss" message too
> verbose. Maybe we should remove it?
> 
> BTW, what are the AP settings (beacon interval, DTIM)? Was power save
> enabled in the driver? If the beacon interval is really long, like 1
> second, our timer is far from optimal and missing beacon only once
> might trigger the warning. We should fix that properly at some point.
> 
and what is its tsf/last beacon in iwlist wlan0 scan?

e.g:
Extra:tsf=0000005a35738ad1
Extra: Last beacon: 2180ms ago

Regards,
	Chr

