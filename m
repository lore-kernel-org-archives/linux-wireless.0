Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56476 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaDYPo3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 11:44:29 -0400
Message-ID: <1398440262.4152.21.camel@jlt4.sipsolutions.net> (sfid-20140425_174440_265736_90704DDB)
Subject: Re: [PATCH 03/12] mac80211: minor changes of ieee80211_reconfig()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 25 Apr 2014 17:37:42 +0200
In-Reply-To: <87k3agjxky.fsf@gmail.com> (sfid-20140423_094828_517020_2623E34C)
References: <cover.1398055853.git.gamerh2o@gmail.com>
	 <d8410804796e01fe8b4c62aeaca97b791154f585.1398055854.git.gamerh2o@gmail.com>
	 <1398178044.4211.9.camel@jlt4.sipsolutions.net> <87k3agjxky.fsf@gmail.com>
	 (sfid-20140423_094828_517020_2623E34C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-23 at 15:48 +0800, Zhao, Gang wrote:
> On Tue, 2014-04-22 at 16:47:24 +0200, Johannes Berg wrote:
> > On Mon, 2014-04-21 at 12:52 +0800, Zhao, Gang wrote:
> >> Try to update chanctx only if local->use_chanctx is true.
> >
> > I'm not convinced this part is correct, since the internal channel
> > context handling also has an effect when the driver doesn't use it.
> 
> Actually ieee80211_assign_chanctx() checks if local->use_chanctx is
> true, so this patch doesn't change the logic. I should mentioned it in
> the commit log.

Oh, you're right. Please also split the patch into two.

johannes

