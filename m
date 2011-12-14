Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54042 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab1LNTA1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 14:00:27 -0500
Date: Wed, 14 Dec 2011 13:54:49 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2 1/2] cfg80211: Define a wrapper function for reporting
 roaming
Message-ID: <20111214185448.GB2607@tuxdriver.com> (sfid-20111214_200030_342884_14737445)
References: <1323265359-1138-1-git-send-email-vthiagar@qca.qualcomm.com>
 <1323265604.3404.37.camel@jlt3.sipsolutions.net>
 <20111207135822.GA12398@chvasanth-lnx>
 <20111207150543.GA12498@chvasanth-lnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111207150543.GA12498@chvasanth-lnx>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 07, 2011 at 08:35:45PM +0530, Vasanthakumar Thiagarajan wrote:
> On Wed, Dec 07, 2011 at 07:28:24PM +0530, Vasanthakumar Thiagarajan wrote:
> > > 
> > > Hmm, now that I think about it more, I think the calling convention is
> > > really strange. Why pass the channel and bssid when the BSS struct is
> > > already known?
> > > 
> > > Why not make cfg80211_roamed() do the BSS lookup (which would also
> > > reduce the race for drivers that don't use _bss()) based on the info,
> > > and then call a cfg80211_roamed_bss() that doesn't get channel/bssid.
> > 
> > Sure, i'll change it. This looks better.
> 
> Also, i'll create a new patch instead of the next version.

Is that patch still coming?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
