Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta11.charter.net ([216.33.127.80]:48977 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab1ISW71 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 18:59:27 -0400
Message-ID: <4E77C951.5010103@gregd.org> (sfid-20110920_005930_624549_B04EC3EE)
Date: Mon, 19 Sep 2011 17:59:29 -0500
From: Greg Dietsche <greg@gregd.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org
Subject: Re: pull request: iwlegacy 2011-09-14
References: <20110914085900.GA2717@redhat.com> <20110919193122.GD2608@tuxdriver.com> <4E77C129.7070203@gregd.org>
In-Reply-To: <4E77C129.7070203@gregd.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/19/2011 05:24 PM, Greg Dietsche wrote:
> On Mon, 19 Sep 2011 15:31:22 -0400, John W. Linville wrote:
>> On Wed, Sep 14, 2011 at 10:59:16AM +0200, Stanislaw Gruszka wrote:
>>> John,
>>>
>>> Please pull iwlegacy cleanup changes done by Greg and me, intended
>>> for 3.2. These request include huge patches with file renaming and
>>> automatic code processing done by sed and indent. Work of changing
>>> iwlegacy driver into something that I could consider maintainable
>>> is not done yet, but these massive changes bring closer into that.
>>> Hopefully with having clean, maintainable code I will be able to
>>> fix some nasty, not easy reproducible bugs, we still have in the
>>> iwlegacy driver.
>>>
>>> Thanks.
>>>
>>> The following changes since commit
>>> d82cdad64a0127611724c61849a8487d69fb76ef:
>>>
>>> Merge branch 'master' of
>>> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next
>>> (2011-08-30 16:34:33 -0400)
>>>
>>> are available in the git repository at:
>>>
>>> git://github.com/dietsche/linux.git
>>> wireless-next-iwlegacy-stanislaw-greg
>>
>> It looks like you pulled something other than wireless-next into this
>> tree. If you want me to pull directly, then you need to based your
>> tree (or at least the branch I'm pulling) on wireless-next
>> exclusively.
>
> Sorry for the confusing branch name! I was naming it based on which
> kernel release the code is for and not where it was branched from. Also,
> I hadn't anticipated that my git tree might end up in pull request...
>
> The branch wireless-next-iwlegacy-stanislaw-greg is based on John's
> wireless-testing tree. Looking at previous emails in this thread, we
> referred to wireless-testing as the base for the changes, so branching
> from wireless-testing was done on purpose.
>
> I briefly tried to apply the patch set to wireless-next, but it doesn't
> like Stanislaw's second patch (rename iwl to il). So some work will need
> to be done if we really need to pull into wireless-next.
>
> I'm not real familiar with the pull process... so let me know if you'd
> like me to do something.
>
>
> Greg


To make things less confusing, I created a new branch and pushed it. you 
can pull from here if you'd like:
git://github.com/dietsche/linux.git 
wireless-testing-2011-09-14-iwlegacy-cleanup


Greg
