Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:27648 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753053AbYAYGHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 01:07:30 -0500
From: bruno randolf <bruno@thinktube.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/3] ath5k: use SWBA to detect IBSS HW merges
Date: Fri, 25 Jan 2008 15:07:17 +0900
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
References: <20080119091759.31251.60264.stgit@one> <20080119091821.31251.5098.stgit@one> <1201166295.3454.52.camel@johannes.berg>
In-Reply-To: <1201166295.3454.52.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801251507.17814.bruno@thinktube.com> (sfid-20080125_060733_996398_0A446C44)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 24 January 2008 18:18:15 Johannes Berg wrote:
> On Sat, 2008-01-19 at 18:18 +0900, Bruno Randolf wrote:
> > time und check if a HW merge (automatic TSF update) has happened on every
> > received beacon with the same BSSID.
>
> I don't know who is smoking what (I suspect Atheros folks...), but
> calling a TSF adoption a "merge" is pretty out of line IMHO when you
> also describe some non-standard BSSID changes as "merge".

hmm, i agree, that calling that a "merge" is a bit over the top. i was using 
this term as somebody mentioned it in 
http://madwifi.org/wiki/DevDocs/AdhocMerge, but i agree that "TSF update" is 
more to the point and clearer.

bruno

