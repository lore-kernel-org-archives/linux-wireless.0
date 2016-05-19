Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39105 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865AbcESNIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2016 09:08:18 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Lauri Kasanen <cand@gmx.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RESEND] Re: updating carl9170-1.fw in linux-firmware.git
References: <20160416113312.8de2266358165182bb4b4a15@gmx.com>
	<2185358.G319l0XIJC@debian64>
	<87wpnrcft4.fsf@kamboji.qca.qualcomm.com>
	<54163090.DmVClckc2L@debian64>
	<20160518114828.bfaef9e4fbe9e039687eab38@gmx.com>
Date: Thu, 19 May 2016 16:08:10 +0300
In-Reply-To: <20160518114828.bfaef9e4fbe9e039687eab38@gmx.com> (Lauri
	Kasanen's message of "Wed, 18 May 2016 11:48:28 +0300")
Message-ID: <87wpmqdwlh.fsf@kamboji.qca.qualcomm.com> (sfid-20160519_150835_491797_B0433CDB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lauri Kasanen <cand@gmx.com> writes:

> On Tue, 03 May 2016 15:09:39 +0200
> Christian Lamparter <chunkeey@googlemail.com> wrote:
>
>> On Thursday, April 21, 2016 03:22:15 PM Kalle Valo wrote:
>> > Christian Lamparter <chunkeey@googlemail.com> writes:
>> > 
>> > > Maintainers. So for those people reading the fw list:
>> > >
>> > > What would it take to update the carl9170-1.fw firmware file in your
>> > > repository to the latest version?
>> > 
>> > Thanks for following up on this. It would be good to solve this finally.
>> Well, this was almost two weeks and no update yet.
>> Kalle, can you please apply the "[PATCH v2] carl9170: Clarify kconfig text"
>> patch from "Lauri Kasanen <cand@gmx.com>" [0].
>> 
>> [0] <https://marc.info/?l=linux-wireless&m=146081633405880>
>
> Seems we missed 4.7?

Yeah, I didn't consider this important enough and delayed it due to lack
of time. I now put the patch back to my queue for 4.8, but please check
that it's the correct version:

https://patchwork.kernel.org/patch/8861621/

But we really should figure out how to get the latest version to
linux-firmware, this is not good in the long run.

-- 
Kalle Valo
