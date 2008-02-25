Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.233]:20500 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbYBYT2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 14:28:53 -0500
Received: by wr-out-0506.google.com with SMTP id c48so2646832wra.23
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 11:28:52 -0800 (PST)
Subject: Re: [PATCH 11/13 v2] o11s: support for on-demand Hybrid Wireless
	Mesh Protocol
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1203697819.7082.75.camel@johannes.berg>
References: <47be77ee.02098c0a.5eba.ffff81ef@mx.google.com>
	 (sfid-20080222_072128_730595_F951750B)  <1203697819.7082.75.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 11:30:29 -0800
Message-Id: <1203967829.6929.16.camel@localhost> (sfid-20080225_192915_060286_85AA04A7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-02-22 at 17:30 +0100, Johannes Berg wrote:
> For each device as in the peer or in the hardware we run on? Would this
> need a new entry in struct ieee80211_hw?

As in the hardware. To have the entry in ieee80211_hw and require the
drivers to fill the value would be the best, the problem would be to
actually find out meaningful values for the hardware.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


