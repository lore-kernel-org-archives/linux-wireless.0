Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:56985 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaDTDjU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2014 23:39:20 -0400
Received: by mail-pd0-f173.google.com with SMTP id z10so2629225pdj.32
        for <linux-wireless@vger.kernel.org>; Sat, 19 Apr 2014 20:39:19 -0700 (PDT)
From: "Zhao\, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 0/3] fix and improvements
References: <cover.1397924746.git.gamerh2o@gmail.com>
Date: Sun, 20 Apr 2014 11:39:06 +0800
In-Reply-To: <cover.1397924746.git.gamerh2o@gmail.com> (Gang Zhao's message of
	"Sun, 20 Apr 2014 00:32:36 +0800")
Message-ID: <87bnvwsm91.fsf@gmail.com> (sfid-20140420_053924_421054_93759668)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-04-20 at 00:32:36 +0800, Zhao, Gang wrote:
> I think the first patch should also be applied to 3.15.
>
> Zhao, Gang (3):
>   cfg80211: fix incorrect checking of return value
>   cfg80211/mac80211: rename cfg80211_chandef_dfs_required()
>   cfg80211: change variable name
>
I found that the incorrect checking of return value problem had already
been fixed in mac80211-next 2beb6dab2d79 ("cfg80211/mac80211: refactor
cfg80211_chandef_dfs_required()"). But not on mac80211 tree.

I think the fix may worth going to mac80211 and also
stable-3.14. Johannes, you can decide whether to apply this patch or it
needs to be modified, since if it's applied, it will surely cause
conflict in future time.

The following two improvement patches should be ignored, since I found
they need to be rebased to be applied on mac80211-next.
