Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42087 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab0LHRAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 12:00:13 -0500
Date: Wed, 8 Dec 2010 11:56:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Bruno Randolf <br1@einfach.org>,
	Jonathan Guerin <jonathan@guerin.id.au>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@venema.h4ckr.net>, nbd@openwrt.org
Subject: Re: ath5k: Weird Retransmission Behaviour
Message-ID: <20101208165607.GE2423@tuxdriver.com>
References: <AANLkTimDF3kofO=kiuOsz+WrTGROdOL8-3eNvKd5NrD3@mail.gmail.com>
 <201012061714.15863.br1@einfach.org>
 <AANLkTi=+bZbsZXR2v1AUKLEEAWGLpq-uNJXQ13t-Bf+D@mail.gmail.com>
 <AANLkTi=95mO085Y1PJ3brMMpHa=QvkxSB3SUpQysvKr+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=95mO085Y1PJ3brMMpHa=QvkxSB3SUpQysvKr+@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 08, 2010 at 11:45:39AM -0500, Bob Copeland wrote:
> On Wed, Dec 8, 2010 at 11:08 AM, Bob Copeland <me@bobcopeland.com> wrote:
> > On Mon, Dec 6, 2010 at 3:14 AM, Bruno Randolf <br1@einfach.org> wrote:
> >> But it seems weird that there are so many retransmissions. The default maximum
> >> numbers of retransmissions should be 7 for short frames and 4 for long frames
> >> (dot11[Short|Long]RetryLimit), and this is what is set as defaults in mac80211
> >> (local->hw.conf.short_frame_max_tx_count). Seems we are getting many
> >> retransmissions from minstel, i added some debug prints:
> >>
> >
> > I posted a patch for this about a week ago to linux-wireless.
> >
> > AFAICT minstrel doesn't use these configuration parrameters
> > at all (but PID does).
> >
> > --
> > Bob Copeland %% www.bobcopeland.com
> >
> 
> Found the patch:
> 
> https://patchwork.kernel.org/patch/359722/

Are you posting that for merging?  Or just for testing?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
