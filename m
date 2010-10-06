Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44310 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227Ab0JFNaH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 09:30:07 -0400
Date: Wed, 6 Oct 2010 09:23:01 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Jaeger <chrjae@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: Why were patches reverted on 2010-09-21? (carl9170 and others)
Message-ID: <20101006132301.GA2472@tuxdriver.com>
References: <AANLkTin9hFUE_RH0Zb4OuV2dU_kJs6_ap=VxEmT3e3F8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTin9hFUE_RH0Zb4OuV2dU_kJs6_ap=VxEmT3e3F8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I swear, I should just stop doing wireless-testing at all...

Let me explain...again...

The history in wireless-testing is dirty.  It contains crap like
these reverts only so that I can continue to pull cleanly from
wireless-next-2.6 and wireless-2.6 even after I have had to rebase
them.  Otherwise, I would have to do lots of pointless fixups in a
tree that will never be pulled by Linus anyway.  The ugly history is
the alternative to rebasing, so that those who pull can do so without
git complaining.

The point of wireless-testing is to provide something between linux-2.6
and linux-next, something that is close to the stabilising release but
with currently pending wireless patches.  It is not intended to be
a basis for historical research.  Don't use it for that.

John

On Tue, Oct 05, 2010 at 07:33:40PM -0400, Christian Jaeger wrote:
> Hello John W. Linville & list,
> 
> I wonder why on 2010-09-21 you reverted a bunch of patches by
> Christian Lamparter, along with others:
> 
> git log d1222bce4344bdbfd1443c310c56a2fa7326ab85..8440f453633abac1503734fb3054b5686c5ac5ae^
> 
> I want to try the carl9170 driver, and so I've done a regex search for
> carl9170 in wireless-testing/master, and cherry-picked them on top of
> the current stable kernel (v2.6.35.7). When double checking I noticed
> these reverts, which left me wondering whether that was an unnoticed
> mistake and I should actually keep all of Christian Lamparter's
> patches. The revert commits don't carry any explanation and I haven't
> found it mentioned in the list archive.
> 
> (The patches applied cleanly, but I haven't built or tested the kernel
> yet; to avoid forgetting to send this notice, I'm sending it away
> already.)
> 
> Thanks
> Christian.
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
