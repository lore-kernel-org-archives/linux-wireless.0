Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:35724 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754328Ab0KXBpF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 20:45:05 -0500
Received: from vs3017.wh2.ocn.ne.jp (125.206.180.250)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0242773103
	for <linux-wireless@vger.kernel.org>; Wed, 24 Nov 2010 10:45:03 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v7 1/3] cfg80211: Add nl80211 antenna configuration
Date: Wed, 24 Nov 2010 10:45:05 +0900
Cc: linville@tuxdriver.com, nbd@openwrt.org, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org
References: <20101110035050.23721.15617.stgit@localhost6.localdomain6> <201011221133.36594.br1@einfach.org> <1290439881.5718.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1290439881.5718.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201011241045.05708.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue November 23 2010 00:31:21 Johannes Berg wrote:
> On Mon, 2010-11-22 at 11:33 +0900, Bruno Randolf wrote:
> > On Sat November 20 2010 03:45:37 Johannes Berg wrote:
> > > You'll need to provide documentation updates for this ASAP.
> > 
> > What do you mean? There is lots of kerneldoc in my patch. Is it not
> > enough?
> 
> Not for the cfg80211 ops afaict, or did I just miss that?

True. Sorry. I will add it.

bruno
