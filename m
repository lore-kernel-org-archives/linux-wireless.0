Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58511 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab3JNMDF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 08:03:05 -0400
Message-ID: <1381752176.13092.10.camel@jlt4.sipsolutions.net> (sfid-20131014_140309_676583_59E58C50)
Subject: Re: [PATCH] cfg80211: fix channel to frequency mapping in 5.9GHz
 range
From: Johannes Berg <johannes@sipsolutions.net>
To: Dennis H Jensen <dennis.h.jensen@siemens.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Mon, 14 Oct 2013 14:02:56 +0200
In-Reply-To: <1381506302.3711.10.camel@djensen-laptop>
References: <1381492780-3068-1-git-send-email-dennis.h.jensen@siemens.com>
	 <1381499778.14293.21.camel@jlt4.sipsolutions.net>
	 <1381506302.3711.10.camel@djensen-laptop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-10-11 at 17:45 +0200, Dennis H Jensen wrote:

> > > +		else if (chan > 196)
> > > +			return 5000 + (chan - 15) * 5;
> > 
> > Where does the +/- 15 come from? I can't find any evidence for this in
> > Annex E.
> 
> I didn't double check Annex E. I just wanted to recover the lost
> frequencies that the 15 channels (182 - 196), map into 4.9 GHz.

"Recover"? When did they work? What broke them?

johannes

