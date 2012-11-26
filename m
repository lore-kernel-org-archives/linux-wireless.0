Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35172 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab2KZKYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 05:24:11 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TcvrG-0000Da-4m
	for linux-wireless@vger.kernel.org; Mon, 26 Nov 2012 11:24:10 +0100
Message-ID: <1353925478.9488.4.camel@jlt4.sipsolutions.net> (sfid-20121126_112415_303899_942A6FC0)
Subject: Re: [PATCH] mac80211: fix radiotap vendor area skipping
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 26 Nov 2012 11:24:38 +0100
In-Reply-To: <1353656499-11817-1-git-send-email-johannes@sipsolutions.net> (sfid-20121123_084116_346366_7F59EB8F)
References: <1353656499-11817-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121123_084116_346366_7F59EB8F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-23 at 08:41 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The radiotap vendor area in the skb head must be skipped
> and accounted for in a few functions until it is removed.
> I missed this in my patch, so a few places use this data
> as though it was the 802.11 header, fix these places.
> 
> Reported-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
> Tested-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied.

johannes

