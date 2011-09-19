Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f42.google.com ([209.85.216.42]:47365 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451Ab1ISTEE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 15:04:04 -0400
Received: by qwi4 with SMTP id 4so18175229qwi.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2011 12:04:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110919190042.9487F40644@repository3.orbit-lab.org>
References: <20110919190042.9487F40644@repository3.orbit-lab.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 19 Sep 2011 12:03:44 -0700
Message-ID: <CAB=NE6UhfNCmuGzARs-HvXAByvecYWw-P54GdeV9x8vJhmgn_A@mail.gmail.com> (sfid-20110919_210409_583051_882D1836)
Subject: Re: Compat-wireless release for 2011-09-19 is baked
To: Compat-wireless cronjob account <compat@orbit-lab.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 19, 2011 at 12:00 PM, Compat-wireless cronjob account
<compat@orbit-lab.org> wrote:
> From git://github.com/mcgrof/compat-wireless
>   d95cf13..a898f60  master     -> origin/master
>  * [new tag]         compat-wireless-2011-09-19 -> compat-wireless-2011-09-19
> From git://github.com/sfrothwell/linux-next
>  + dc978c7...7f694ea akpm-end   -> origin/akpm-end  (forced update)
>   9e79e3e..b0e7031  akpm-start -> origin/akpm-start
>  + 95a6714...28ad777 master     -> origin/master  (forced update)
>   9e79e3e..b0e7031  stable     -> origin/stable
>  * [new tag]         next-20110919 -> next-20110919
> From git://github.com/sfrothwell/linux-next
>  * [new tag]         v3.1-rc5   -> v3.1-rc5
>  * [new tag]         v3.1-rc6   -> v3.1-rc6
>
> compat-wireless code metrics
>
>    811531 - Total upstream lines of code being pulled
>      2397 - backport code changes
>      2086 - backport code additions
>       311 - backport code deletions
>      8527 - backport from compat module
>     10924 - total backport code
>    1.3461 - % of code consists of backport work

OK we're back on track, Stephen gave me a github URL that worked. I'll
be using that until further notice.

  Luis

> ssh: Could not resolve hostname wireless.kernel.org: Name or service not known
> rsync: connection unexpectedly closed (0 bytes received so far) [sender]
> rsync error: unexplained error (code 255) at io.c(601) [sender=3.0.7]

This is korg's DNS, I'll switch this to use "linuxwireless.org" for
now which still does resolve appropriately.

  Luis
