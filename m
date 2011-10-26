Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48310 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab1JZTIr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 15:08:47 -0400
Subject: Re: a-MSDU question (bug in debugfs?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4EA8597A.50609@candelatech.com> (sfid-20111026_210325_886708_85470263)
References: <4EA8597A.50609@candelatech.com>
	 (sfid-20111026_210325_886708_85470263)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Oct 2011 21:08:43 +0200
Message-ID: <1319656123.4229.11.camel@jlt3.sipsolutions.net> (sfid-20111026_210850_199147_75E1309A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-10-26 at 12:03 -0700, Ben Greear wrote:
> This code from net/mac80211/debugfs_sta.c appears to say that
> if the IEEE80211_HT_CAP_MAX_AMSDU is set, we are at value 3839,
> but elsewhere on the web it appears the opposite.
> 
> Anyone know what is correct?  I'm having no good luck finding
> an official document about this...
> 
>                 PRINT_HT_CAP((htc->cap & BIT(11)), "Max AMSDU length: "
>                               "3839 bytes");
>                  PRINT_HT_CAP(!(htc->cap & BIT(11)), "Max AMSDU length: "
>                               "7935 bytes");

iw also has the other way around and I probably would have checked
against 802.11n. If you can't find that google for getieee

johannes

