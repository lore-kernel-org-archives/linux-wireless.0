Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:34969 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab3FEQtp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 12:49:45 -0400
Date: Wed, 5 Jun 2013 17:49:42 +0100
From: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>,
	Luciano Coelho <coelho@ti.com>
Subject: Re: wireless tree rebased (from 5/28), Broadcom bits dropped
Message-ID: <20130605164942.GB3047@joana> (sfid-20130605_184948_268545_F3503BD5)
References: <20130604212602.GB11199@tuxdriver.com>
 <20130604215320.GC11199@tuxdriver.com>
 <1370415586.8920.4.camel@jlt4.sipsolutions.net>
 <20130605143700.GA2271@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130605143700.GA2271@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* John W. Linville <linville@tuxdriver.com> [2013-06-05 10:37:01 -0400]:

> On Wed, Jun 05, 2013 at 08:59:46AM +0200, Johannes Berg wrote:
> > On Tue, 2013-06-04 at 17:53 -0400, John W. Linville wrote:
> > > I messed this up too -- bad day...
> > > 
> > > If you pulled in between the earlier message and this one, please
> > > do so again.  If you saw this message before taking any action to
> > > clean-up my mess, then you are OK.
> > 
> > This was confusing, I think you rebased around some merges instead of
> > redoing the merges? My patches are in, but suddenly got new commit IDs,
> > e.g. fa331699d05ce1d0d4896eb4a137cfae50d7afde (new) vs.
> > c2c15e215e860c99b86ddfc4be4bb25cf180fed0 for "mac80211: work around
> > broken APs not including HT info".
> > 
> > This will cause git to pull them in again when I send a new pull
> > request, so it would have been nicer to redo the merges, but anyway ...
> > just a heads-up for everyone that here it's a bit confusing now.
> > 
> > johannes
> 
> You are right, I could have done it better with regard to your tree.
> I probably should redo that part.
> 
> The Bluetooth tree had pulled the wireless tree and applied their
> patches on top of the brcmfmac/brcmsmac series that I removed.  So,
> their pull couldn't be redone.

The Bluetooth commit IDs have changed too, but I just did a rebase on top
your tree and it is all set here now. I'll wait for your rebase today and see
how things goes.

	Gustavo
