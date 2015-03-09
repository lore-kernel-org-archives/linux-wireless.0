Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57793 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbbCIIfv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 04:35:51 -0400
Message-ID: <1425890148.1928.3.camel@sipsolutions.net> (sfid-20150309_093559_389209_8B9CCE50)
Subject: Re: [RFC v2] [RFC] mac80211: lock rate control
From: Johannes Berg <johannes@sipsolutions.net>
To: Sven Eckelmann <sven@open-mesh.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Date: Mon, 09 Mar 2015 09:35:48 +0100
In-Reply-To: <1741038.iCoNEntVIV@bentobox> (sfid-20150309_093212_837963_F79703B8)
References: <1425575237-5556-1-git-send-email-johannes@sipsolutions.net>
	 <2736671.Y6Lt54SxyK@bentobox> <1425639348.3339.2.camel@sipsolutions.net>
	 <1741038.iCoNEntVIV@bentobox> (sfid-20150309_093212_837963_F79703B8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-09 at 09:32 +0100, Sven Eckelmann wrote:
> On Friday 06 March 2015 11:55:48 Johannes Berg wrote:
> > > I will just add following modification to your patch and ask for a new
> > > test.
> >
> > Let me know how that goes :)
> 
> I got a reply and they informed me that the test looked promising. The test 
> setup didn't crash and was running stable for hours. It looks like the extra 
> locking in rate_control_rate_init around ref->ops->rate_init was the missing 
> part in your patch that was necessary fix the problem for them.

Great, thanks for testing.

johannes

