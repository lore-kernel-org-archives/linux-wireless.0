Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44493 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab1LGPGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 10:06:08 -0500
Date: Wed, 7 Dec 2011 20:35:45 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 1/2] cfg80211: Define a wrapper function for reporting
 roaming
Message-ID: <20111207150543.GA12498@chvasanth-lnx> (sfid-20111207_160616_960239_196C2D04)
References: <1323265359-1138-1-git-send-email-vthiagar@qca.qualcomm.com>
 <1323265604.3404.37.camel@jlt3.sipsolutions.net>
 <20111207135822.GA12398@chvasanth-lnx>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20111207135822.GA12398@chvasanth-lnx>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 07, 2011 at 07:28:24PM +0530, Vasanthakumar Thiagarajan wrote:
> > 
> > Hmm, now that I think about it more, I think the calling convention is
> > really strange. Why pass the channel and bssid when the BSS struct is
> > already known?
> > 
> > Why not make cfg80211_roamed() do the BSS lookup (which would also
> > reduce the race for drivers that don't use _bss()) based on the info,
> > and then call a cfg80211_roamed_bss() that doesn't get channel/bssid.
> 
> Sure, i'll change it. This looks better.

Also, i'll create a new patch instead of the next version.

Vasanth
