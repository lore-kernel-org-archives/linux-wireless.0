Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:58493 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758322Ab2EKJEB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 05:04:01 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Luciano Coelho <coelho@ti.com>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org,
	assaf@ti.com
Subject: Re: [PATCH 00/78] 18xx chip support
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
	<87ipg48ivh.fsf@purkki.adurom.net>
	<1336715845.12189.160.camel@cumari.coelho.fi>
Date: Fri, 11 May 2012 12:03:58 +0300
In-Reply-To: <1336715845.12189.160.camel@cumari.coelho.fi> (Luciano Coelho's
	message of "Fri, 11 May 2012 08:57:25 +0300")
Message-ID: <87aa1f84xt.fsf@purkki.adurom.net> (sfid-20120511_110411_295537_E86688E1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luca,

Luciano Coelho <coelho@ti.com> writes:

> On Thu, 2012-05-10 at 12:50 +0300, Kalle Valo wrote:
>> Arik Nemtsov <arik@wizery.com> writes:
>> 
>> > This series adds initial support for the 18xx chip family. The new
>> > module uses wlcore for functionality common with the 12xx family.
>> 
>> You do know that sending 78 patches in one patchset is very much
>> frowned upon? No sane person (outside of wl12xx) is going to review
>> all of these.
>

[...]

> So, unless you or someone else really disagrees, I'll apply these to the
> wl12xx.git tree.

I don't like this method of sending patches with the "take it or leave it"
attitude, because there's really no way to give any feedback to a series
of 78 patches. But I'm not going to go berserk either if you take the
patch bomb, it's really up to you.

But I can promise you that I will complain everytime I see a patch bomb
like this, and I will get louder after each iteration. And as you know,
I have a really loud voice :)

> And then I'll go find Arik to remove some of his fingernails, especially
> the one on his right hand pinky so he can't hit ENTER so quickly after
> typing git send-email. :P

Please still try to be gentle ;)

-- 
Kalle Valo
