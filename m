Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51253 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab0IVS7h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 14:59:37 -0400
Date: Wed, 22 Sep 2010 14:48:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [mac80211] mac80211:  Support multiple VIFS per AP in debugfs.
Message-ID: <20100922184846.GI5515@tuxdriver.com>
References: <1285071310-11440-1-git-send-email-greearb@candelatech.com>
 <4C98DC5D.2000108@candelatech.com>
 <1285086618.12764.3.camel@jlt3.sipsolutions.net>
 <4C98E05B.8050609@candelatech.com>
 <1285088605.12764.5.camel@jlt3.sipsolutions.net>
 <1285091341.12764.7.camel@jlt3.sipsolutions.net>
 <4C9A35FD.8060201@candelatech.com>
 <1285174896.3684.71.camel@jlt3.sipsolutions.net>
 <4C9A3E1C.8070306@candelatech.com>
 <1285180265.3684.74.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1285180265.3684.74.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 22, 2010 at 08:31:05PM +0200, Johannes Berg wrote:
> On Wed, 2010-09-22 at 10:34 -0700, Ben Greear wrote:
> 
> > @@ -308,7 +308,7 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
> >          if (!stations_dir)
> >                  return;
> > 
> > -       snprintf(mac, sizeof(mac), "%pM", sta->sta.addr);
> > +       snprintf(mac, sizeof(mac), "sta-%pM", sta->sta.addr);
> 
> Wouldn't a stations/ subdirectory in netdev:wlan0 be nicer? I don't
> really care too much -- what do others think?

Sounds better that way to me too...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
