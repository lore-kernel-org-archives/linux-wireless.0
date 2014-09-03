Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32855 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478AbaICMer (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 08:34:47 -0400
Message-ID: <1409747676.911.16.camel@jlt4.sipsolutions.net> (sfid-20140903_150113_808968_121B45F2)
Subject: Re: [Patch]mac80211: Add support for mesh proxy path dump
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Date: Wed, 03 Sep 2014 14:34:36 +0200
In-Reply-To: <CAGnRvur4g03Ut1fiMybUy=zdA=ponAMQKbd-vc_i1RaQsThJhQ@mail.gmail.com> (sfid-20140903_143300_916190_ADFBF766)
References: <2937689.hWkxdbjQ3v@rogge-hp-probook-6470b>
	 <1409745133.911.7.camel@jlt4.sipsolutions.net>
	 <CAGnRvurXEzkekvYA2bLnObNMpxytH0G1tgXnF5c=90wBCoWmRA@mail.gmail.com>
	 <1409747141.911.15.camel@jlt4.sipsolutions.net>
	 <CAGnRvur4g03Ut1fiMybUy=zdA=ponAMQKbd-vc_i1RaQsThJhQ@mail.gmail.com>
	 (sfid-20140903_143300_916190_ADFBF766)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-09-03 at 14:32 +0200, Henning Rogge wrote:

> > No need, I just wasn't sure it really needed the same data so figured
> > I'd ask.
> 
> At the moment I don't use much of the mpath_info field... but I think
> the mpp operations will always use a subset of the mpath fields, so we
> can reuse the nl80211 encoding function by reusing the struct. If this
> changes it would be trivial to switch to a different struct, because
> its not visible from userspace.

Makes sense I guess. Thanks for the explanation.

johannes

