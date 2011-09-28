Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56822 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab1I1H2n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 03:28:43 -0400
Subject: Re: Questions on ieee80211_frame_duration()
From: Johannes Berg <johannes@sipsolutions.net>
To: Roland Vossen <rvossen@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4E82CA8C.9060102@broadcom.com>
References: <4E81A098.9040708@broadcom.com>
	 <1317121805.4082.10.camel@jlt3.sipsolutions.net>
	 <4E82CA8C.9060102@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 09:28:41 +0200
Message-ID: <1317194921.3986.6.camel@jlt3.sipsolutions.net> (sfid-20110928_092846_662387_9689959B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Roland,

> >> The function does not seem to take the last two types into account.
> >> Should it ?
> >
> > I suppose it needs to. I'd be happy if you would fix it :-)
> 
> I feel a bit uncomfortable changing such a critical function, especially 
> since I am not that familiar with Mac80211 design yet. So don't expect 
> miracles from me on the short term :-)

:-)
I suspect it's actually not very critical for most drivers.

johannes

