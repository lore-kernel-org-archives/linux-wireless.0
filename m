Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58204 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbZDNNPu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 09:15:50 -0400
Date: Tue, 14 Apr 2009 09:02:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Forest Bond <forest@alittletooquiet.net>,
	Greg KH <greg@kroah.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
Message-ID: <20090414130248.GA3291@tuxdriver.com> (sfid-20090414_151553_418915_E8A1982D)
References: <20090414105200.GE25746@storm.local.network> <1239707258.4778.3.camel@johannes.local> <20090414113928.GA20470@storm.local.network> <1239709727.4778.6.camel@johannes.local> <1239712106.11795.21.camel@violet> <1239713034.17109.10.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1239713034.17109.10.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 14, 2009 at 02:43:54PM +0200, Johannes Berg wrote:
> Hi Marcel,
> 
> > just to document the irony here. Two or three years ago at OLS, Kyle and
> > Greg were making fun of Ubuntu merging its 5th wireless stack into their
> > kernel. Now the staging crap is doing exactly the same.
> 
> :)
> 
> Actually, last I counted it was already 7 or 8 stacks in staging _only_.
> This (and the other patch) will add two more. Not to mention that of
> course we already have something like two and a half stacks in the
> kernel tree (mac80211, in hostapd, and libipw [former ieee80211]).

FWIW I had started trying to consolidate some code between those three.
I stalled-out a bit and got distracted with the rndis_wlan cfg80211
bits, but I hope to get back to it.  Of course, hostap seems mighty
complex internally -- it might just have to lay there.  And libipw
and mac80211 target different types of designs, but I hope they can
eventually share some infrastructure in lib80211.

None of the above is meant to disagree about the staging crap.
Having that stuff around is at best an optimistic attempt to help a
few stray users... :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
