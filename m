Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40148 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764Ab3CSU15 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 16:27:57 -0400
Message-ID: <1363724866.8336.22.camel@jlt4.sipsolutions.net> (sfid-20130319_212805_031231_44C7954F)
Subject: Re: [RFC] P2P find offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 19 Mar 2013 21:27:46 +0100
In-Reply-To: <3959922.dEpYdEMVAq@lx-vladimir>
References: <3408094.SIuA27EmQ5@lx-vladimir>
	 <1958495.JVcc1yGep9@lx-vladimir>
	 <1363638685.8260.32.camel@jlt4.sipsolutions.net>
	 <3959922.dEpYdEMVAq@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-03-19 at 19:35 +0200, Vladimir Kondratiev wrote:
> > I was under the impression that wpa_s allowed "progressive" (i.e.
> one
> > non-social channel per iteration) even in find? I could be wrong
> though,
> > maybe only in search.

> wpa_s do it in that "legacy" scan before find phase

No: p2p_find type=progressive

If this will no longer be supported, I guess you can say so. I also
don't really see how the API could support it, but it is a potential
issue.


> > Ok, but can you also document what the driver should add? Supported
> > rates, HT info, ... presumably?
> 
> It is same case as for 'scan' or 'start_ap' - driver expect to deal
> with
> IE's same way. There we don't say anything, why do it here?

Maybe we're better now? ;-)

I guess I'm not too concerned about this.

> Anything more I expected to do with patch? Or, is it on its way to
> your git?

Send as [PATCH] for sure, but we should think about the progressive
thing.

johannes

