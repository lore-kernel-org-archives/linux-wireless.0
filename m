Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41757 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab2GDKMh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 06:12:37 -0400
Message-ID: <1341396753.4482.13.camel@jlt3.sipsolutions.net> (sfid-20120704_121240_929493_99D55DAD)
Subject: Re: [PATCH v2] mac80211: tx: do not drop non-robust mgmt to non-MFP
 stas.
From: Johannes Berg <johannes@sipsolutions.net>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Date: Wed, 04 Jul 2012 12:12:33 +0200
In-Reply-To: <4FF414D9.4060509@lri.fr>
References: <1341393221-5396-1-git-send-email-cavallar@lri.fr>
	 <1341394528.4482.4.camel@jlt3.sipsolutions.net> <4FF414D9.4060509@lri.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-04 at 12:03 +0200, Nicolas Cavallari wrote:

> > Hmmm. Yes, all this seems a bit messy. Can we clean this up first?
> 
> The whole function is a bit messy. some clean ups would be nice
> but it is too easy to break corner cases.

Yeah ...

> > Maybe something like this?
> > http://p.sipsolutions.net/d68a99dd3d9b1ab1.txt
> 
> No problem for me. I didn't want that patch to too intrusive at first.

Can you review it? :)

> Do you want to apply it yourself ? or should i include it in a series ?

Then ... probably easiest for you to include it so you can work on top.
Here's a version with commit log:
http://p.sipsolutions.net/17ea0ebece544a59.txt

> > The whole drop_unencrypted seems strange to start with though...
> 
> what to you find strange ? that it is not used in a ESS, or how it works
> ? or both ?

The way it's used/works/isn't used.

johannes

