Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933754AbbCPQCB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 12:02:01 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: "M. Vefa Bicakci" <m.v.b@runbox.com>
Cc: Matthias Beyer <mail@beyermatthias.de>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	joe@perches.com, Larry.Finger@lwfinger.net,
	gregkh@linuxfoundation.org
Subject: Re: [PATCH v2 00/16] checkpatch clean-up of rtl8723au's rtw_security.c
References: <1426378241-32469-1-git-send-email-m.v.b@runbox.com>
	<20150315093142.GY24643@lucy.3gs> <10669062.ZZNVxH5Tl9@lenny>
Date: Mon, 16 Mar 2015 12:01:33 -0400
In-Reply-To: <10669062.ZZNVxH5Tl9@lenny> (M. Vefa Bicakci's message of "Sun,
	15 Mar 2015 09:51 -0400")
Message-ID: <wrfjvbi1rkwy.fsf@ultrasam.lan.trained-monkey.org> (sfid-20150316_170227_838480_832E4B14)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"M. Vefa Bicakci" <m.v.b@runbox.com> writes:
> Hello Matthias,
>
> Thank you for reviewing the patches!
>
> I have based and tested these commits on Stephen Rothwell's
> linux-next.git/master branch. It is possible that I made a mistake
> by doing this.
>
> Nevertheless, I have just verified that these patches cleanly apply to the
> current version of Greg Kroah-Hartman's staging.git/staging-next branch, [1]
> as well as Stephen Rothwell's linux-next.git/master branch. [2]
>
> In my local repo, here are my remotes:
>
> $ git remote -v | grep -E "staging|next" | grep "(fetch)$"
> next
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (fetch)
> staging
> https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> (fetch)
>
>
> I have just fetched both of these remotes.
>
> $ git log -1 --oneline next/master
> a68b04c773 Add linux-next specific files for 20150313
>
> $ git log -1 --oneline staging/staging-next 
> 7aa5d5097d Staging: rtl8192u: Use __packed instead of __attribute__((packed))
>
>
> And here are my two local branches with my commits applied:
>
> # Output slightly edited to reduce line length.
> $ git branch -vv | grep -E "staging|next"
> * linux-next c8ab62fb9c [next/master: ahead 16] staging: rtl8723au:
> Remove unneeded comments
>   staging-next 63f451681e [staging/staging-next: ahead 16] staging:
> rtl8723au: Remove unneeded comments
>
>
> I hope this clarifies my set-up. Is there something I am doing incorrectly?
> If there is anything I can assist with, please let me know.
>
> Thank you,
>
> Vefa
>
> [1]
> https://git.kernel.org/cgit/linux/kernel/git/gregkh/staging.git/log/?h=staging-next
> [2] https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/log/

For staging patches, you should always post patches against the
staging-next tree. Please rebase them and repost them.

Jes
