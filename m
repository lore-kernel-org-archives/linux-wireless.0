Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:22202 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752296Ab0LAGsP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 01:48:15 -0500
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0818066089
	for <linux-wireless@vger.kernel.org>; Wed,  1 Dec 2010 15:48:12 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v7 1/3] cfg80211: Add nl80211 antenna configuration
Date: Wed, 1 Dec 2010 15:47:48 +0900
Cc: linville@tuxdriver.com, nbd@openwrt.org, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org
References: <20101110035050.23721.15617.stgit@localhost6.localdomain6> <201011241045.05708.br1@einfach.org> <1291185817.4199.5.camel@jlt3.sipsolutions.net>
In-Reply-To: <1291185817.4199.5.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201012011547.48339.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed December 1 2010 15:43:37 Johannes Berg wrote:
> On Wed, 2010-11-24 at 10:45 +0900, Bruno Randolf wrote:
> > On Tue November 23 2010 00:31:21 Johannes Berg wrote:
> > > On Mon, 2010-11-22 at 11:33 +0900, Bruno Randolf wrote:
> > > > On Sat November 20 2010 03:45:37 Johannes Berg wrote:
> > > > > You'll need to provide documentation updates for this ASAP.
> > > > 
> > > > What do you mean? There is lots of kerneldoc in my patch. Is it not
> > > > enough?
> > > 
> > > Not for the cfg80211 ops afaict, or did I just miss that?
> > 
> > True. Sorry. I will add it.
> 
> Ping.

Already merged.

git show 79b1c460a0b55e55981c25c56597c4d5d2872de3
