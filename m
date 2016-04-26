Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50131 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbcDZJGP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 05:06:15 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] ti: Convert wl1271_<level> logging macros to dev_<level> or pr_<level>
References: <cover.1457395071.git.joe@perches.com>
	<760b583e96a9a88f06e97150617f791c3726a302.1457395071.git.joe@perches.com>
Date: Tue, 26 Apr 2016 12:06:09 +0300
In-Reply-To: <760b583e96a9a88f06e97150617f791c3726a302.1457395071.git.joe@perches.com>
	(Joe Perches's message of "Mon, 7 Mar 2016 16:19:33 -0800")
Message-ID: <87d1pczqm6.fsf@kamboji.qca.qualcomm.com> (sfid-20160426_110718_337895_CB0B9AE0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

> Use the more common logging mechanism passing wl->dev where
> appropriate.  Remove the macros.  Add argument struct wl1271 *wl to
> some functions to make these logging mechanisms work.
>
> Miscellanea:
>
> o Coalesce formats, add required trailing \n to formats
>   Some formats already had previously incorrect \n uses
> o Realign arguments
> o Correct a couple typos and grammar defects
> o Split a multiple line error message to multiple calls of dev_err
> o Add #define pr_fmt when pr_<level> is used
> o Remove unnecessary/duplicate pr_fmt use from wl1271_debug macro
>
> Signed-off-by: Joe Perches <joe@perches.com>

Doesn't apply anymore:

Applying: ti: Convert wl1271_<level> logging macros to dev_<level> or pr_<level>
Using index info to reconstruct a base tree...
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/ti/wlcore/wlcore_i.h
Auto-merging drivers/net/wireless/ti/wlcore/tx.c
Auto-merging drivers/net/wireless/ti/wlcore/scan.c
Auto-merging drivers/net/wireless/ti/wlcore/rx.c
Auto-merging drivers/net/wireless/ti/wlcore/ps.c
Auto-merging drivers/net/wireless/ti/wlcore/main.c
Auto-merging drivers/net/wireless/ti/wlcore/cmd.c
CONFLICT (content): Merge conflict in drivers/net/wireless/ti/wlcore/cmd.c
Auto-merging drivers/net/wireless/ti/wl18xx/tx.c
Auto-merging drivers/net/wireless/ti/wl18xx/scan.c
Auto-merging drivers/net/wireless/ti/wl18xx/main.c
Auto-merging drivers/net/wireless/ti/wl18xx/event.c
Auto-merging drivers/net/wireless/ti/wl18xx/debugfs.c
Auto-merging drivers/net/wireless/ti/wl18xx/cmd.c
Auto-merging drivers/net/wireless/ti/wl12xx/scan.c
Auto-merging drivers/net/wireless/ti/wl12xx/main.c
Failed to merge in the changes.

-- 
Kalle Valo
