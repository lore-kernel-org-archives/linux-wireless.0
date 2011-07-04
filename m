Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51785 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab1GDSbo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 14:31:44 -0400
Received: by qwk3 with SMTP id 3so2549054qwk.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jul 2011 11:31:43 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <loom.20110630T161632-452@post.gmane.org>
References: <loom.20110630T161632-452@post.gmane.org>
Date: Mon, 4 Jul 2011 20:31:43 +0200
Message-ID: <CA+icZUUQwN5uZiSPjWikboH=zrU2Wi6vDHCLUoirF92EMuy2PQ@mail.gmail.com> (sfid-20110704_203153_707234_980FD819)
Subject: Re: Broadcom 14e4:4357 mode monitor
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: lululatortue <lefrancoisfabien@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

# Clone the remote GIT repository (master GIT branch)
git clone git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6.git

# Change to local GIT repository
cd staging-2.6

# Switch to staging-next GIT branch
git checkout -b staging-next origin/staging-next

# Check on which branch you are
git branch -l

- Sedat -

On Thu, Jun 30, 2011 at 4:34 PM, lululatortue
<lefrancoisfabien@gmail.com> wrote:
> Hello,
>
>     My objectif is to drive my broadcom with monitor mode. I would download the
> staging-next git tree, available at :
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
>
>     but with my linux write:
>
>    git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
>
>    I'have:
>
> Initialized empty Git repository in /home/lefrancois/staging-next-2.6/.git/
> fatal: The remote end hung up unexpectedly
>
>
>    you know were i can found solution why see unexpectedly or if i want have
> your autorisation for download with my computeur?
>
>
>     2.6.32-32-generic ubuntu 10.04LTS with version git-core (1:1.7.0.4-1ubuntu0.2)
>
>     thank you
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
