Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:24758 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750928AbYAXFv5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 00:51:57 -0500
From: bruno randolf <bruno@thinktube.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Date: Thu, 24 Jan 2008 14:51:49 +0900
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>,
	ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, Ulrich Kunitz <kune@deine-taler.de>,
	Daniel Drake <dsd@gentoo.org>,
	Adam Baker <linux@baker-net.org.uk>
References: <20080118125252.6455.41047.stgit@one> <200801201143.09488.IvDoorn@gmail.com> <1201099791.3454.19.camel@johannes.berg>
In-Reply-To: <1201099791.3454.19.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801241451.49586.bruno@thinktube.com> (sfid-20080124_055201_815281_4C62A22F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 January 2008 23:49:51 Johannes Berg wrote:
> > Then there is a problem for rt2x00. Since the mactime isn't known.
> > rt2400pci is the _only_ device which has a RX_END_TIME field in the
> > RX descriptor.
>
> I don't think it's required for IBSS to function, only for this from my
> POV dubious "merge" functionality.

also you might want to check if your hard- or firmware (if you have any) 
handles IBSS merges already, especially with USB devices. i can't imagine how 
a device driver without access to that information is supposed to merge IBSS.

bruno
