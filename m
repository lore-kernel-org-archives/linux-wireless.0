Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53431 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbcAVMLc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2016 07:11:32 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: wireless-drivers: random cleanup patches piling up
References: <87wpr3x9ln.fsf@kamboji.qca.qualcomm.com>
	<56A13587.7040809@lwfinger.net>
Date: Fri, 22 Jan 2016 14:11:25 +0200
In-Reply-To: <56A13587.7040809@lwfinger.net> (Larry Finger's message of "Thu,
	21 Jan 2016 13:46:15 -0600")
Message-ID: <87si1px18y.fsf@kamboji.qca.qualcomm.com> (sfid-20160122_131151_201177_564A1C97)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> We might get new developers, but the cost may be high. In the staging
> tree, things are worse. The tools can be applied in a blind fashion,
> but the results can be really stupid. GregKH has told a few would-be
> contributors to "go away" after a few patches that would not build.
>
> As most of these patches are based on "problems" found by application
> of various standard tools, they will likely be resubmitted over and
> over until the code is "fixed". Whether the patches are useful may not
> be the main question.
>
> My real complaint with these patches is that very few are more than
> compile tested. For example, there are 3 patches for memory leaks in
> b43. One (https://patchwork.kernel.org/patch/7998941) was rejected
> because it missed some such leaks, but there was not a formal NACK.
> The patch was fixed and resubmitted
> (https://patchwork.kernel.org/patch/8014311/), but not yet tested. The
> author then resent it (https://patchwork.kernel.org/patch/8049041/)
> and was chastised for resending as it still had not been tested. Of
> course, the first two of these can be dropped. Unfortunately, there
> are very few devs who have the necessary hardware to test.
>
> Most of the current set do not account for the directory restructuring
> and will not apply.Those can be rejected with the appropriate message
> asking that they be rebased. That should not require too much of your
> time. That will at last clean out the current backlog.

Actually 'git am -3' handles the directory restructuring just fine, so
that's not a problem. And I can also manage the current backlog, it just
takes some time to clear it up. I'm just worried that these cleanup
patches become even a bigger problem in the future.

> Is it possible for us to require the patch author to supply the level
> of testing when that is not obvious? This information should be in the
> comments location after the first ---. I suspect I know the answer for
> non-maintainers, but the formal requirement might be helpful. 

I think that's a good idea. If it's only compile tested that should be
properly documented in the commit log so that people are aware of it.

> I also promise to be more diligent in reviewing the patches that are
> directed at the drivers that I maintain.

Thanks, I appreciate that.

-- 
Kalle Valo
