Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39603 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab3CKP0C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 11:26:02 -0400
Message-ID: <1363015558.5284.11.camel@jlt4.sipsolutions.net> (sfid-20130311_162606_662907_9F709AA0)
Subject: Re: [PATCH] mac80211: Enable sw scan with chan context
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 11 Mar 2013 17:25:58 +0200
In-Reply-To: <513DF675.3000800@posedge.com>
References: <513DE4BB.9010104@posedge.com>
	 <1363012784.5284.5.camel@jlt4.sipsolutions.net>
	 <513DF675.3000800@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-11 at 20:51 +0530, Mahesh Palivela wrote:

> I tested this patch. scan works. 

Works how? It never tells the driver to go to a different channel ...

Besides, telling the driver to go to one channel via the hw_config call,
and using chanctx for vif configuration seems like a really bad idea.

> Anyways chan context is a WIP.

It pretty much works.

> There is no driver which is using the chan ctx work yet.

There is, our mvm driver uses it.

> I will continue adding code for chan ctx.

What are you trying to achieve anyway?

johannes

