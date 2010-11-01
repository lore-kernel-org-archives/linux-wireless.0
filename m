Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-da01.nokia.com ([147.243.128.24]:18197 "EHLO
	mgw-da01.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab0KATPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 15:15:13 -0400
Subject: Re: [PATCH 2/2] wl1271: refactor debugfs function generation code
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Eliad Peller <eliad@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1288184310-6781-2-git-send-email-eliad@wizery.com>
References: <1288184310-6781-1-git-send-email-eliad@wizery.com>
	 <1288184310-6781-2-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Nov 2010 21:23:23 +0200
Message-ID: <1288639403.21112.50.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-27 at 14:58 +0200, ext Eliad Peller wrote:
> refactor wl1271_debugfs by using a format&copy function, instead of
> duplicating the code for each generated function.
> 
> this change reduces about 3Kb from wl1271.ko
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Looks good, thanks!

Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>

I have applied this patch, but I won't apply the one for mac80211 [1/2],
because patches for mac80211 go directly to linux-wireless.

John, can you apply patch [1/2], the mac80211 part, separately on your
tree? If Johannes agrees, of course.  This one I'll send together with
my next pull request.  

PS: I have fixed a couple of whitespace checkpatch warnings.

-- 
Cheers,
Luca.

