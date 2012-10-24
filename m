Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47230 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965182Ab2JXPVp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 11:21:45 -0400
Message-ID: <1351092137.10709.4.camel@jlt4.sipsolutions.net> (sfid-20121024_172211_161081_EB300A52)
Subject: Re: [PATCH] mac80211: use blacklist for duplicate IE check
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 24 Oct 2012 17:22:17 +0200
In-Reply-To: <CAMcMvshEVhQspmd19WAtPWqD846d2zkBf3AX4ChU1b-AV5JbSQ@mail.gmail.com> (sfid-20121024_171954_890512_74605C77)
References: <1351081297-14623-1-git-send-email-johannes@sipsolutions.net>
	 <CAMcMvshEVhQspmd19WAtPWqD846d2zkBf3AX4ChU1b-AV5JbSQ@mail.gmail.com>
	 (sfid-20121024_171954_890512_74605C77)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-24 at 08:19 -0700, Paul Stewart wrote:

> On Wed, Oct 24, 2012 at 5:21 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>         From: Johannes Berg <johannes.berg@intel.com>
>         
>         Instead of the current whitelist which accepts duplicates
>         only for the quiet and vendor IEs, use a blacklist of all
>         IEs (that we currently parse) that can't be duplicated.
>         
>         This avoids detecting a beacon as corrupt in the future
>         when new IEs are added that can be duplicated.
>         
>         Cc: Paul Stewart <pstew@chromium.org>
>         Cc: stable@vger.kernel.org
>         Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Paul Stewart <pstew@chromium.org>

Your mail was HTML so it probably didn't make it to the list, but I'll
take it as an endorsement, thanks for reviewing :)

johannes


