Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:56120 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab3ACFSD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 00:18:03 -0500
Received: by mail-ie0-f172.google.com with SMTP id c13so18008100ieb.31
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jan 2013 21:18:02 -0800 (PST)
Date: Thu, 3 Jan 2013 00:16:18 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, thomas@cozybit.com,
	devel@lists.open80211s.org
Subject: Re: [PATCH/RFC] nl80211/cfg80211/mac80211: add
 NL80211_CMD_GET_MESH_SETUP
Message-ID: <20130103051618.GF13185@localhost> (sfid-20130103_061810_492547_04953324)
References: <20121214151442.GA10736@localhost>
 <1356705826.9922.17.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1356705826.9922.17.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 28, 2012 at 03:43:46PM +0100, Johannes Berg wrote:
> On Fri, 2012-12-14 at 10:14 -0500, Bob Copeland wrote:
> > Presumably, once someone implements beacon collision avoidance,
> > I'd rather have the current dtim/beacon_int values, which isn't
> > really setup anymore, but maybe we don't care so much.
> 
> Seems fine, but I think you should document the latter. OTOH, maybe it
> should just be documented that the setup values are hints only when that
> is implemented ...

I plan to look at MBCA soon, so I'll think on it a bit.

-- 
Bob Copeland %% www.bobcopeland.com
