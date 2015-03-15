Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:49675 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbbCONvO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 09:51:14 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: Matthias Beyer <mail@beyermatthias.de>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	joe@perches.com, Larry.Finger@lwfinger.net,
	gregkh@linuxfoundation.org, Jes.Sorensen@redhat.com
Subject: Re: [PATCH v2 00/16] checkpatch clean-up of rtl8723au's rtw_security.c
Date: Sun, 15 Mar 2015 09:51 -0400
Message-ID: <10669062.ZZNVxH5Tl9@lenny> (sfid-20150315_145131_776795_7F5237F4)
In-Reply-To: <20150315093142.GY24643@lucy.3gs>
References: <1426378241-32469-1-git-send-email-m.v.b@runbox.com> <20150315093142.GY24643@lucy.3gs>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, March 15, 2015 10:31:42 Matthias Beyer wrote:
> Hi,
> 
> On 14-03-2015 20:10:25, M. Vefa Bicakci wrote:
> > These commits address a number of checkpatch.pl warnings and errors
> > in rtl8723au's rtw_security.c.
> 
> Were these patches already applied? I cannot apply them on top of Greg
> KHs latest staging-next!
> 
> I reviewed them and I want to add Reviewed-by: tags, but I would like
> to apply them on my kernel source copy first, just to re-check them!

Hello Matthias,

Thank you for reviewing the patches!

I have based and tested these commits on Stephen Rothwell's
linux-next.git/master branch. It is possible that I made a mistake
by doing this.

Nevertheless, I have just verified that these patches cleanly apply to the
current version of Greg Kroah-Hartman's staging.git/staging-next branch, [1]
as well as Stephen Rothwell's linux-next.git/master branch. [2]

In my local repo, here are my remotes:

$ git remote -v | grep -E "staging|next" | grep "(fetch)$"
next    https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git (fetch)
staging https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git (fetch)


I have just fetched both of these remotes.

$ git log -1 --oneline next/master
a68b04c773 Add linux-next specific files for 20150313

$ git log -1 --oneline staging/staging-next 
7aa5d5097d Staging: rtl8192u: Use __packed instead of __attribute__((packed))


And here are my two local branches with my commits applied:

# Output slightly edited to reduce line length.
$ git branch -vv | grep -E "staging|next"
* linux-next    c8ab62fb9c [next/master: ahead 16] staging: rtl8723au: Remove unneeded comments
  staging-next  63f451681e [staging/staging-next: ahead 16] staging: rtl8723au: Remove unneeded comments


I hope this clarifies my set-up. Is there something I am doing incorrectly?
If there is anything I can assist with, please let me know.

Thank you,

Vefa

[1] https://git.kernel.org/cgit/linux/kernel/git/gregkh/staging.git/log/?h=staging-next
[2] https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/log/

