Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40845 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab1LTHQr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 02:16:47 -0500
Received: by iaeh11 with SMTP id h11so9832884iae.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 23:16:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EF00EEB.2010006@gmail.com>
References: <CAB=NE6WfBDqQzqxNaZm5mMhjyP2t7M-5t=+RA-A2JAKUKjmJzw@mail.gmail.com>
 <4EF00EEB.2010006@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 19 Dec 2011 23:16:25 -0800
Message-ID: <CAB=NE6Waa5X8p3J343HQGnz6t1Lvn1+ZyQi0pAr50G5z7cUxWQ@mail.gmail.com> (sfid-20111220_081651_222521_03213C5B)
Subject: Re: [ANN] compat-wireless for 3.2-rc6
To: Richard Farina <sidhayn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 19, 2011 at 8:28 PM, Richard Farina <sidhayn@gmail.com> wrote:
> On 12/19/11 22:55, Luis R. Rodriguez wrote:
>>
>> You all know what this is, only difference is we have a few
>> pending-stable patches not yet merged into Linus' tree but that are on
>> linux-next.git so we suck those in and provide an "-s" release. Below
>> are the statistics of both releases. We have an "-s" release [1] and a
>> vanilla release [2]. I'll note that I expect a few set of patches are
>> desirable to cherry pick from linux-next.git for a type of stable
>> release that we will support but for now I have yet to hear back which
>> patches those are. Feel free to reply here with the sha1sums you want
>> but please be specific of the linux-next.git tag you used.
>>
>> For the -s release:
>>
>> Updated from local tree: /home/mcgrof/linux-stable
>> Origin remote URL:
>> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
>>
>> compat-wireless code metrics
>>
>>     814570 - Total upstream lines of code being pulled
>>       2488 - backport code changes
>>       2143 - backport code additions
>>        345 - backport code deletions
>>       8670 - backport from compat module
>>      11158 - total backport code
>>     1.3698 - % of code consists of backport work
>>         57 - Code changes brought in from pending-stable
>>         44 - Code additions brought in from pending-stable
>>         13 - Code deletions brought in from pending-stable
>>     0.0070 - % of code being cherry picked from pending-stable
>>
>> Base tree: linux-stable.git
>> Base tree version: v3.2-rc6
>> compat-wireless release: compat-wireless-v3.2-rc6-3-s
>>
>> For the vanilla release:
>>
>> Updated from local tree: /home/mcgrof/linux-stable
>> Origin remote URL:
>> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
>>
>> compat-wireless code metrics
>>
>>     814570 - Total upstream lines of code being pulled
>>       2488 - backport code changes
>>       2143 - backport code additions
>>        345 - backport code deletions
>>       8670 - backport from compat module
>>      11158 - total backport code
>>     1.3698 - % of code consists of backport work
>>
>> Base tree: linux-stable.git
>> Base tree version: v3.2-rc6
>> compat-wireless release: compat-wireless-v3.2-rc6-3
>>
>> [1]
>> http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.2/compat-wireless-3.2-rc6-3-s.tar.bz2
>> [2]
>> http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.2/compat-wireless-3.2-rc1-1.tar.bz2
>> --
>
> Not sure how much anyone cares,

Depends. Does is this issue present for any official kernel 2.6.27..3.1?

> but this doesn't compile on gentoo hardened.

What's the delta between whatever gentoo hardened has vs its
respective vanilla stable release? RHEL and Debian seem to do some
nasty shit on their own, I welcome patches for distribution hacks if
someone is willing to maintain that crap for their own distribution.

  Luis
