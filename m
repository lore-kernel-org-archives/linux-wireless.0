Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:48199 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752173AbZAEE7Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 23:59:25 -0500
Message-ID: <496193A6.3040608@lwfinger.net> (sfid-20090105_055931_443161_0E4E3397)
Date: Sun, 04 Jan 2009 22:59:18 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: rate instability in wireless stack
References: <20090104164649.GV496@one.firstfloor.org> <200901041736.47650.mb@bu3sch.de> <20090104174123.GW496@one.firstfloor.org> <49615465.4090604@lwfinger.net> <20090105025302.GF496@one.firstfloor.org> <49618497.50809@lwfinger.net> <20090105050248.GG496@one.firstfloor.org>
In-Reply-To: <20090105050248.GG496@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andi Kleen wrote:
> On Sun, Jan 04, 2009 at 09:55:03PM -0600, Larry Finger wrote:
> 
> Minstrel stays constantly at 1 Mbit/s

Do you have mac80211 debugging turned on? If so, then do a

sudo cat /sys/kernel/debug/ieee80211/phyXX/stations/<MAC ADDR>/rc_stats

and post them.

Thanks,

Larry

