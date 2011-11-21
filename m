Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:39550 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab1KUPdF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 10:33:05 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Greg Dietsche <gregory.dietsche@cuw.edu>,
	linux-wireless@vger.kernel.org
Subject: Re: pull request: iwlegacy 2011-11-16
References: <20111116122205.GA4409@redhat.com>
	<87y5vf8ak3.fsf@purkki.adurom.net>
	<20111117190307.GE32622@tuxdriver.com>
	<20111118073041.GA2203@redhat.com>
Date: Mon, 21 Nov 2011 17:32:59 +0200
In-Reply-To: <20111118073041.GA2203@redhat.com> (Stanislaw Gruszka's message
	of "Fri, 18 Nov 2011 08:30:42 +0100")
Message-ID: <87vcqdij84.fsf@purkki.adurom.net> (sfid-20111121_163317_680131_556947BF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Thu, Nov 17, 2011 at 02:03:08PM -0500, John W. Linville wrote:
>> On Thu, Nov 17, 2011 at 09:36:44AM +0200, Kalle Valo wrote:
>> > Stanislaw Gruszka <sgruszka@redhat.com> writes:
>>
>> > I haven't seen these patches on linux-wireless mailing list at all.
>
> I did not post them because most of them are big patches done by sed or
> "git mv", nothing that would benefit from review.

If you use git's rename detection patches moving files shouldn't be
large. And besides, if you are doing so big changes that patches are too
big for the mailing list I think you are doing something wrong.

> Anyway, if someone like to look at the patches, its better to just pull
> github tree, or even clone it. It used with --reference option clone
> will be fast, i.e:
>
> git clone --reference linux-2.6  git://github.com/sgruszka/iwlegacy.git

Nobody is going to do review from a git tree unless forced. That's why
we review via email.

-- 
Kalle Valo
