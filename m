Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35555 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab1GSW0w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 18:26:52 -0400
Subject: Re: Kernel oops in code added by "cfg80211: allow userspace to
 control supported rates in scan"
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4E25FEB3.1030005@gnu.org>
References: <4E25FA60.7040807@gnu.org>
	 (sfid-20110719_234302_063697_7FDE84C7) <1311112517.3872.0.camel@jlt3.sipsolutions.net>
	 <4E25FEB3.1030005@gnu.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jul 2011 00:26:47 +0200
Message-ID: <1311114408.3872.1.camel@jlt3.sipsolutions.net> (sfid-20110720_002655_070477_D48D7C1C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-07-19 at 18:01 -0400, Pavel Roskin wrote:
> On 07/19/2011 05:55 PM, Johannes Berg wrote:
> > On Tue, 2011-07-19 at 17:42 -0400, Pavel Roskin wrote:
> >
> >> for (i = 0; i<  IEEE80211_NUM_BANDS; i++)
> >>         request->rates[i] = (1<<  wiphy->bands[i]->n_bitrates) - 1;
> >
> > Ah crap, I didn't pay attention and never tested a single-band card.
> > Below change should fix it.
> 
> Tested-by: Pavel Roskin <proski@gnu.org>
> 
> The ultimate test - sending via the wireless connection :)

:)
I'll run another test to see if it actually _works_ on single-band cards
and submit it, sorry about that!

johannes

