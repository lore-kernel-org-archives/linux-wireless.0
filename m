Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:33803 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654Ab1HYJLZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 05:11:25 -0400
To: Thomas Pedersen <thomas@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: refactor skb copy to failq in mesh_path_move_to_queue
References: <1314213161-8871-1-git-send-email-linville@tuxdriver.com>
	<CAG6hwVNvLREnnZQ0t8UaKZ7Q1nn-4kx=z_1nPzVG89a5NMWFpg@mail.gmail.com>
	<20110824193224.GL9770@tuxdriver.com>
	<CAG6hwVMWMGXZMfnQSLQD6BCSG0kuP_0C6rKs_XYwmK4v7esRsQ@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 25 Aug 2011 12:11:23 +0300
In-Reply-To: <CAG6hwVMWMGXZMfnQSLQD6BCSG0kuP_0C6rKs_XYwmK4v7esRsQ@mail.gmail.com> (Thomas Pedersen's message of "Wed\, 24 Aug 2011 13\:06\:11 -0700")
Message-ID: <87ipplonyc.fsf@purkki.adurom.net> (sfid-20110825_111129_980067_E14B4AB8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thomas Pedersen <thomas@cozybit.com> writes:

>>> However, this does look nicer. Please be sure to apply the version
>>> submitted on 11 August.
>>
>> You just told me yesterday to apply the 9 August version???
>>
>
> OK that is confusing. I meant 9 August version of patch 1/8 only, the
> rest should be 11 August.

WTF, this is the second time I'm reading something like this in 24 hours?

John has loads of things to do already. If something changes in the
series series, ask John to drop that version and RESUBMIT IT! Don't
force John to waste time by trying to find the correct versions of
your patch from the past.

I want to John to focus on more important things than doing the work
of the people who don't bother to resubmit their patches. Resubmitting
a patch series takes maximum of 10 minutes, even when being extra
careful.

-- 
Kalle Valo
