Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35063 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934434Ab2DLPzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 11:55:47 -0400
Message-ID: <1334246145.4062.0.camel@jlt3.sipsolutions.net> (sfid-20120412_175550_211978_80E3CB9F)
Subject: Re: Suspicious RCU usage in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Date: Thu, 12 Apr 2012 17:55:45 +0200
In-Reply-To: <4F86FA05.5080404@lwfinger.net> (sfid-20120412_175209_622126_B8DC3474)
References: <4F83A6DE.7070109@lwfinger.net>
	   (sfid-20120410_052034_062782_82AB2FD8) <1334201497.3788.1.camel@jlt3.sipsolutions.net>
	  <4F865155.2000202@lwfinger.net>
	 (sfid-20120412_055225_110383_5156780F) <1334202842.3788.10.camel@jlt3.sipsolutions.net>
	 <4F86FA05.5080404@lwfinger.net> (sfid-20120412_175209_622126_B8DC3474)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-04-12 at 10:51 -0500, Larry Finger wrote:
> On 04/11/2012 10:54 PM, Johannes Berg wrote:
> >
> > What do you mean by "every time"? I wouldn't expect the timer to fire
> > every time you set up aggregation etc., the timer firing is a special
> > case to start with.
> 
> I meant it is intermittent, or it required some special setup that I have not 
> duplicated, as I have seen the condition only once.

Ok. I suspect that's explained by the fact that the timer is an error
case anyway, so you've probably never seen that error case again. It's
still puzzling though since the code looks fine to me.

johannes

