Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:36138 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab1LTE2k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 23:28:40 -0500
Received: by qadb15 with SMTP id b15so3771674qad.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 20:28:39 -0800 (PST)
Message-ID: <4EF00EEB.2010006@gmail.com> (sfid-20111220_052855_318138_9FFE6E77)
Date: Mon, 19 Dec 2011 23:28:27 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ANN] compat-wireless for 3.2-rc6
References: <CAB=NE6WfBDqQzqxNaZm5mMhjyP2t7M-5t=+RA-A2JAKUKjmJzw@mail.gmail.com>
In-Reply-To: <CAB=NE6WfBDqQzqxNaZm5mMhjyP2t7M-5t=+RA-A2JAKUKjmJzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/19/11 22:55, Luis R. Rodriguez wrote:
> You all know what this is, only difference is we have a few
> pending-stable patches not yet merged into Linus' tree but that are on
> linux-next.git so we suck those in and provide an "-s" release. Below
> are the statistics of both releases. We have an "-s" release [1] and a
> vanilla release [2]. I'll note that I expect a few set of patches are
> desirable to cherry pick from linux-next.git for a type of stable
> release that we will support but for now I have yet to hear back which
> patches those are. Feel free to reply here with the sha1sums you want
> but please be specific of the linux-next.git tag you used.
>
> For the -s release:
>
> Updated from local tree: /home/mcgrof/linux-stable
> Origin remote URL:
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
>
> compat-wireless code metrics
>
>      814570 - Total upstream lines of code being pulled
>        2488 - backport code changes
>        2143 - backport code additions
>         345 - backport code deletions
>        8670 - backport from compat module
>       11158 - total backport code
>      1.3698 - % of code consists of backport work
>          57 - Code changes brought in from pending-stable
>          44 - Code additions brought in from pending-stable
>          13 - Code deletions brought in from pending-stable
>      0.0070 - % of code being cherry picked from pending-stable
>
> Base tree: linux-stable.git
> Base tree version: v3.2-rc6
> compat-wireless release: compat-wireless-v3.2-rc6-3-s
>
> For the vanilla release:
>
> Updated from local tree: /home/mcgrof/linux-stable
> Origin remote URL:
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
>
> compat-wireless code metrics
>
>      814570 - Total upstream lines of code being pulled
>        2488 - backport code changes
>        2143 - backport code additions
>         345 - backport code deletions
>        8670 - backport from compat module
>       11158 - total backport code
>      1.3698 - % of code consists of backport work
>
> Base tree: linux-stable.git
> Base tree version: v3.2-rc6
> compat-wireless release: compat-wireless-v3.2-rc6-3
>
> [1] http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.2/compat-wireless-3.2-rc6-3-s.tar.bz2
> [2] http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.2/compat-wireless-3.2-rc1-1.tar.bz2
> --
Not sure how much anyone cares, but this doesn't compile on gentoo hardened.

  CC [M]  
/var/tmp/portage/net-wireless/compat-wireless-3.2_rc6/work/compat-wireless-3.2-rc6-3-s/net/mac80211/cfg.o
/var/tmp/portage/net-wireless/compat-wireless-3.2_rc6/work/compat-wireless-3.2-rc6-3-s/drivers/net/wireless/ath/ath9k/ar9002_mac.c: 
In function 'ar9002_set_txdesc':
/var/tmp/portage/net-wireless/compat-wireless-3.2_rc6/work/compat-wireless-3.2-rc6-3-s/drivers/net/wireless/ath/ath9k/ar9002_mac.c:186:2: 
error: assignment of read-only location '*(const volatile u32 
*)&ads->ds_link'
/var/tmp/portage/net-wireless/compat-wireless-3.2_rc6/work/compat-wireless-3.2-rc6-3-s/drivers/net/wireless/ath/ath9k/ar9002_mac.c:187:2: 
error: assignment of read-only location '*(const volatile u32 
*)&ads->ds_data'
/var/tmp/portage/net-wireless/compat-wireless-3.2_rc6/work/compat-wireless-3.2-rc6-3-s/drivers/net/wireless/ath/ath9k/ar9002_mac.c:206:4: 
error: assignment of read-only location '*(const volatile u32 
*)&ads->u.tx.ctl2'
/var/tmp/portage/net-wireless/compat-wireless-3.2_rc6/work/compat-wireless-3.2-rc6-3-s/drivers/net/wireless/ath/ath9k/ar9002_mac.c:211:4: 
error: assignment of read-only location '*(const volatile u32 
*)&ads->u.tx.ctl3'
/var/tmp/portage/net-wireless/compat-wireless-3.2_rc6/work/compat-wireless-3.2-rc6-3-s/drivers/net/wireless/ath/ath9k/ar9002_mac.c:213:3: 
error: assignment of read-only location '*(const volatile u32 
*)&ads->u.tx.ctl2'
/var/tmp/portage/net-wireless/compat-wireless-3.2_rc6/work/compat-wireless-3.2-rc6-3-s/drivers/net/wireless/ath/ath9k/ar9002_mac.c:214:3: 
error: assignment of read-only location '*(const volatile u32 
*)&ads->u.tx.ctl3'
/var/tmp/portage/net-wireless/compat-wireless-3.2_rc6/work/compat-wireless-3.2-rc6-3-s/drivers/net/wireless/ath/ath9k/ar9002_mac.c:218:3: 
error: assignment of read-only location '*(const volatile u32 
*)&ads->ds_ctl0'
/var/tmp/portage/net-wireless/compat-wireless-3.2_rc6/work/compat-wireless-3.2-rc6-3-s/drivers/net/wireless/ath/ath9k/ar9002_mac.c:219:3: 
error: assignment of read-only location '*(const volatile u32 
*)&ads->ds_ctl1'
/var/tmp/portage/net-wireless/compat-wireless-3.2_rc6/work/compat-wireless-3.2-rc6-3-s/drivers/net/wireless/ath/ath9k/ar9002_mac.c:220:3: 
error: assignment of read-only location '*(const volatile u32 
*)&ads->u.tx.ctl6'
/var/tmp/portage/net-wireless/compat-wireless-3.2_rc6/work/compat-wireless-3.2-rc6-3-s/drivers/net/wireless/ath/ath9k/ar9002_mac.c:253:6: 
error: assignment of read-only location '*(const volatile u32 
*)&ads->ds_ctl0'
/var/tmp/portage/net-wireless/compat-wireless-3.2_rc6/work/compat-wireless-3.2-rc6-3-s/drivers/net/wireless/ath/ath9k/ar9002_mac.c:255:2: 
error: assignment of read-only location '*(const volatile u32 
*)&ads->ds_ctl1'
/var/tmp/portage/net-wireless/compat-wireless-3.2_rc6/work/compat-wireless-3.2-rc6-3-s/drivers/net/wireless/ath/ath9k/ar9002_mac.c:256:2: 
error: assignment of read-only location '*(const volatile u32 
*)&ads->u.tx.ctl6'
/var/tmp/portage/net-wireless/compat-wireless-3.2_rc6/work/compat-wireless-3.2-rc6-3-s/drivers/net/wireless/ath/ath9k/ar9002_mac.c:262:3: 
error: assignment of read-only location '*(const volatile u32 
*)&ads->u.tx.ctl4'
/var/tmp/portage/net-wireless/compat-wireless-3.2_rc6/work/compat-wireless-3.2-rc6-3-s/drivers/net/wireless/ath/ath9k/ar9002_mac.c:265:3: 
error: assignment of read-only location '*(const volatile u32 
*)&ads->u.tx.ctl5'
/var/tmp/portage/net-wireless/compat-wireless-3.2_rc6/work/compat-wireless-3.2-rc6-3-s/drivers/net/wireless/ath/ath9k/ar9002_mac.c:271:3: 
error: assignment of read-only location '*(const volatile u32 
*)&ads->u.tx.ctl7'
At top level:
cc1: warning: unrecognized command line option 
"-Wno-unused-but-set-variable"
make[5]: *** 
[/var/tmp/portage/net-wireless/compat-wireless-3.2_rc6/work/compat-wireless-3.2-rc6-3-s/drivers/net/wireless/ath/ath9k/ar9002_mac.o] 
Error 1
make[4]: *** 
[/var/tmp/portage/net-wireless/compat-wireless-3.2_rc6/work/compat-wireless-3.2-rc6-3-s/drivers/net/wireless/ath/ath9k] 
Error 2
make[3]: *** 
[/var/tmp/portage/net-wireless/compat-wireless-3.2_rc6/work/compat-wireless-3.2-rc6-3-s/drivers/net/wireless/ath] 
Error 2
make[2]: *** 
[/var/tmp/portage/net-wireless/compat-wireless-3.2_rc6/work/compat-wireless-3.2-rc6-3-s/drivers/net/wireless] 
Error 2

Happy to provide any additional details requested.

Thanks,
Zero
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

