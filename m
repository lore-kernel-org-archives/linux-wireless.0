Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42270 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab2KMUfa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 15:35:30 -0500
Message-ID: <1352838957.9466.32.camel@jlt4.sipsolutions.net> (sfid-20121113_213533_531492_D7DAB4B9)
Subject: Re: [PATCHv3] mac80211: deinitialize ibss-internals after emptiness
 check
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Ignacy Gawedzki <i@lri.fr>
Date: Tue, 13 Nov 2012 21:35:57 +0100
In-Reply-To: <1352828583-19502-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1352828583-19502-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-13 at 18:43 +0100, Simon Wunderlich wrote:
> The check whether the IBSS is active and can be removed should be
> performed before deinitializing the fields used for the check/search.
> Otherwise, the configured BSS will not be found and removed properly.
> 
> To make it more clear for the future, rename sdata->u.ibss to the
> local pointer ifibss which is used within the checks.
> 
> This behaviour was introduced by
> f3209bea110cade12e2b133da8b8499689cb0e2e
> ("mac80211: fix IBSS teardown race")

Applied.

johannes

