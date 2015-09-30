Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51761 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932481AbbI3TEP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 15:04:15 -0400
Message-ID: <1443639852.1859.25.camel@sipsolutions.net> (sfid-20150930_210458_455285_1A1DCF14)
Subject: Re: Rate limiting AP bandwidth change messages in
 ieee80211_config_bw?
From: Johannes Berg <johannes@sipsolutions.net>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: drago01 <drago01@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	"Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Date: Wed, 30 Sep 2015 21:04:12 +0200
In-Reply-To: <1443637937.1859.19.camel@sipsolutions.net> (sfid-20150930_203253_594716_3CF517AD)
References: <CA+5PVA4yaLG2NtJ_Bg5-BQzR-Wa5ABxPb-cLxF7bjSsf-P1_5Q@mail.gmail.com>
	 (sfid-20150930_190254_762697_55F052FA) <1443637937.1859.19.camel@sipsolutions.net>
	 (sfid-20150930_203253_594716_3CF517AD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> 
> I'm not sure ratelimiting it would even work - it's not *that* high
> frequency? Not really sure though.
> 
> I think we can do either, it's not such a terribly important message as
> far as I can tell.
> 

Seems like Emmanuel would like to see the message stay in some form -
perhaps we should try rate limiting it then? Could you check if that
actually works?

johannes






