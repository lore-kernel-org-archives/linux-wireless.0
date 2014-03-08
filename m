Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:49354 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaCHEeY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 23:34:24 -0500
Received: by mail-pa0-f50.google.com with SMTP id kq14so5046798pab.9
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2014 20:34:24 -0800 (PST)
From: "Zhao\, Gang" <gamerh2o@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] mac80211: compute chanctx refcount dynamically
References: <1394191196-6425-1-git-send-email-michal.kazior@tieto.com>
	<1394191196-6425-3-git-send-email-michal.kazior@tieto.com>
	<1394203467.4653.15.camel@jlt4.sipsolutions.net>
Date: Sat, 08 Mar 2014 12:34:17 +0800
In-Reply-To: <1394203467.4653.15.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Fri, 07 Mar 2014 15:44:27 +0100")
Message-ID: <87ha79s3zq.fsf@will.lan> (sfid-20140308_053451_710773_648C40EA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-07 at 22:44:27 +0800, Johannes Berg wrote:
[...]
> Of course I don't mind if you want to just wait for me to be back, I'm
> happy to do the merging and then complain about patches that need
> rebasing, just be warned that that would likely only happen after the
> 17th.

My patch "mac80211: refactor recalculate channel context functions" can
wait, and I can rebase them if needed.

>
> johannes
