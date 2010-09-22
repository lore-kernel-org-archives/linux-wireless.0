Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51486 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab0IVRBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 13:01:39 -0400
Subject: Re: [mac80211] mac80211:  Support multiple VIFS per AP in debugfs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4C9A35FD.8060201@candelatech.com>
References: <1285071310-11440-1-git-send-email-greearb@candelatech.com>
	 <4C98DC5D.2000108@candelatech.com>
	 <1285086618.12764.3.camel@jlt3.sipsolutions.net>
	 <4C98E05B.8050609@candelatech.com>
	 <1285088605.12764.5.camel@jlt3.sipsolutions.net>
	 <1285091341.12764.7.camel@jlt3.sipsolutions.net>
	 <4C9A35FD.8060201@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 19:01:36 +0200
Message-ID: <1285174896.3684.71.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-22 at 09:59 -0700, Ben Greear wrote:

> > maybe the stations should be moved from phy0/stations/ to
> > phy0/wlan0/stations/ instead?
> 
> It doesn't matter either way to me, but I'd like to get one or another
> patch upstream.
> 
> If you want me to change it to put stations under netdev:wlan0/ instead,
> please just let me know.

I'd prefer that, if you want to do this.

johannes

