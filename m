Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55331 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab0DMHVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 03:21:25 -0400
Subject: Re: [PATCH 2/2] mac80211: Initialize IBSS basic rates according to
 band
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <201004130916.18626.br1@einfach.org>
References: <20100412073658.28078.32155.stgit@tt-desk>
	 <201004121734.39700.br1@einfach.org>
	 <1271061652.3877.8.camel@jlt3.sipsolutions.net>
	 <201004130916.18626.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 09:21:15 +0200
Message-ID: <1271143275.4885.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-04-13 at 09:16 +0900, Bruno Randolf wrote:
> On Monday 12 April 2010 17:40:52 you wrote:
> > On Mon, 2010-04-12 at 17:34 +0900, Bruno Randolf wrote:
> > > before we unconditionally used 3 (1Mbps, 2 Mbps) as basic rates. this
> > > clearly is wrong in the 5GHz band.
> > 
> > No, it's fine. Look again at how this works.
> 
> (hello? can you please stop treating me like an idiot?)
> 
> this means we use 6 and 9 as basic rates in the 5GHz band.
> we should use 6, 12 and 24.

No, we can treat 6 and 9 as basic rates if we want to when we create the
IBSS. You seem to be confusing basic and mandatory rates or something
else that I can't make sense of. It's NOT "clearly wrong".

johannes

