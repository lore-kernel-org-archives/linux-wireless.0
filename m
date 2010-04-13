Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:34884 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754322Ab0DMAQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 20:16:17 -0400
Received: from vs3003.wh2.ocn.ne.jp (125.206.180.231)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0950917772
	for <linux-wireless@vger.kernel.org>; Tue, 13 Apr 2010 09:16:15 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: Initialize IBSS basic rates according to band
Date: Tue, 13 Apr 2010 09:16:18 +0900
References: <20100412073658.28078.32155.stgit@tt-desk> <201004121734.39700.br1@einfach.org> <1271061652.3877.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1271061652.3877.8.camel@jlt3.sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201004130916.18626.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 12 April 2010 17:40:52 you wrote:
> On Mon, 2010-04-12 at 17:34 +0900, Bruno Randolf wrote:
> > before we unconditionally used 3 (1Mbps, 2 Mbps) as basic rates. this
> > clearly is wrong in the 5GHz band.
> 
> No, it's fine. Look again at how this works.

(hello? can you please stop treating me like an idiot?)

this means we use 6 and 9 as basic rates in the 5GHz band.
we should use 6, 12 and 24.

bruno
