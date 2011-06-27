Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50137 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757549Ab1F0MkE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 08:40:04 -0400
Subject: Re: [PATCH] mac80211: Drop DS Channel PARAM in directed probe
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20110623172630.F038820191@glenhelen.mtv.corp.google.com> (sfid-20110623_192641_605567_2DA48ECC)
References: <20110623172630.F038820191@glenhelen.mtv.corp.google.com>
	 (sfid-20110623_192641_605567_2DA48ECC)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 14:40:03 +0200
Message-ID: <1309178403.3911.12.camel@jlt3.sipsolutions.net> (sfid-20110627_144741_065073_0E225A93)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-06-23 at 09:00 -0800, Paul Stewart wrote:
> Do not send DS Channel parameter for directed probe requests
> in order to maximize the chance that we get a response.  Some
> badly-behaved APs don't respond when this parameter is included.
> 
> Signed-off-by: Paul Stewart <pstew@chromium.org>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Thanks Paul, this is a good workaround, hopefully those broken devices
won't ever support hidden SSIDs.

johannes

