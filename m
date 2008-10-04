Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:39074 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbYJDUaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2008 16:30:17 -0400
Received: by qw-out-2122.google.com with SMTP id 3so477393qwe.37
        for <linux-wireless@vger.kernel.org>; Sat, 04 Oct 2008 13:30:14 -0700 (PDT)
Message-ID: <69e28c910810041330q1034bcc3rad339c7c2fd626@mail.gmail.com> (sfid-20081004_223021_794595_445438B5)
Date: Sat, 4 Oct 2008 22:30:14 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: Ramesh <rramesh1@gmail.com>
Subject: Re: Question on git pull
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <c9d168940810041320p1b09b1f6i51f898011b14b26d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <c9d168940810041320p1b09b1f6i51f898011b14b26d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 4, 2008 at 10:20 PM, Ramesh <rramesh1@gmail.com> wrote:
> Hello,
>
> I am newbie to linux-wireless, I recently got a copy of the source
> from the wireless-testing branch by the following method:
>
> git-clone git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
> cd wireless-testing
> git-pull
>
> I wanted to work on my own branch so I created a new branch as below:
>
> git-checkout -b mac80211-stats-change
>
> I have a few questions at this point :
>
> How do I keep this branch updated with checkins in the master branch?
>
> Thanks
> Ramesh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

You need to periodically rebase the branch using git-rebase.
Alternatively, you can do this sequence:
-Revert all changes you made to the branch
-Pull the latest upstream changes using git-pull
git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
-Reapply your changes.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
