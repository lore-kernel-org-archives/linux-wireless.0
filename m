Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35900 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab0CTNAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Mar 2010 09:00:11 -0400
Date: Sat, 20 Mar 2010 08:48:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dave <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: correct typos in "unavailable upon resume"
	warning
Message-ID: <20100320124818.GA7255@tuxdriver.com>
References: <1268854418-6662-1-git-send-email-linville@tuxdriver.com> <4BA49EE2.8000902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4BA49EE2.8000902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 20, 2010 at 10:09:38AM +0000, Dave wrote:
> John W. Linville wrote:
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > ---
> >  net/mac80211/util.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> > index c453226..a9d9098 100644
> > --- a/net/mac80211/util.c
> > +++ b/net/mac80211/util.c
> > @@ -1097,8 +1097,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
> >  		 */
> >  		res = drv_start(local);
> >  		if (res) {
> > -			WARN(local->suspended, "Harware became unavailable "
> > -			     "upon resume. This is could be a software issue"
> > +			WARN(local->suspended, "Hardware became unavailable "
> > +			     "upon resume. This is could be a software issue "
> 
>                                                 ^^
> 
> As long as you're addressing that line, you probably want to lose the
> 'is'. Or the 'could be'.

Yes, thanks.  Obviously I suck as a proof-reader...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
