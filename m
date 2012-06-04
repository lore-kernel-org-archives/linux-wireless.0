Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40264 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab2FDQSx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 12:18:53 -0400
Message-ID: <1338826731.4512.24.camel@jlt3.sipsolutions.net> (sfid-20120604_181856_034243_5406D052)
Subject: Re: [RFC] cfg80211: Fix incompatible interfaces combination
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 04 Jun 2012 18:18:51 +0200
In-Reply-To: <4FCCDF78.4040606@qca.qualcomm.com>
References: <1338824836-2283-1-git-send-email-mohammed@qca.qualcomm.com>
		 <1338825141.4512.14.camel@jlt3.sipsolutions.net>
		 <4FCCDB63.3040806@qca.qualcomm.com>
	 <1338826398.4512.23.camel@jlt3.sipsolutions.net>
	 <4FCCDF78.4040606@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-04 at 21:46 +0530, Mohammed Shafi Shajakhan wrote:

> >> i am able to create an IBSS interface even if a STA interface is up and
> >> running in ath9k(removing the driver checks).
> >>
> >> this patch ensures that if we have an incompatible interface, it is the
> >> only one can that can exist.
> >
> > Right, ok, I see that it's broken now, trying to see if there's a better
> > fix though.
> 
> sure, thank you.

I'm not really sure, but if I understand the code & problem correctly I
think this should also help:
http://p.sipsolutions.net/a57eeac50c248408.txt

Untested though.

johannes

