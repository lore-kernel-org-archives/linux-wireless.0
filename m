Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60236 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932731AbcFCPwN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 11:52:13 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mike@fireburn.co.uk" <mike@fireburn.co.uk>
Subject: Re: Bug 119151 - [regression] ath10k no longer authenitcates and
 freezes system
Date: Fri, 3 Jun 2016 15:52:03 +0000
Message-ID: <871t4ew9r1.fsf@kamboji.qca.qualcomm.com> (sfid-20160603_175233_212976_DE896B37)
References: <8760trzoiw.fsf@kamboji.qca.qualcomm.com>
	<871t4fzn1x.fsf@kamboji.qca.qualcomm.com>	<57504F05.3040200@candelatech.com>
	<87k2i7y5m2.fsf@kamboji.qca.qualcomm.com>	<57505179.8090509@candelatech.com>
In-Reply-To: <57505179.8090509@candelatech.com> (Ben Greear's message of "Thu,
	2 Jun 2016 08:32:09 -0700")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 06/02/2016 08:26 AM, Valo, Kalle wrote:
>> Ben Greear <greearb@candelatech.com> writes:
>>
>>> I found a lot of problems with this code as well, and the 5 patches
>>> starting from the URL below fixed the issues for me.
>>>
>>> They are stuck as 'NA' in patchwork, but I don't know why.
>>>
>>> http://lists.infradead.org/pipermail/ath10k/2016-April/007218.html
>>
>> ath10k has a separate patchwork instance, did you look at the correct
>> one? I have quite a lot of patches from you in deferred state because of
>> the patch bomb, but I'm hoping to go through them soon.
>>
>> https://patchwork.kernel.org/project/ath10k/list/?state=10&delegate=25621&order=date
>
> Ok, they are deferred then.
>
> The series of 5 is likely quite useful and fixes some nasty bugs,
> and the first patch of the big bomb is also a trivial crash fix
> for a regression you added (as best as I can tell).
>
> The rest of the patch bomb is less critical, but making some progress on
> that would make me feel good about working on ath10k patches again.

If I get a big patchset like 25 patches it immediately goes to the
bottom of the queue. Organising them a bit better takes like 15 minutes
of your time and makes it a lot easier to review. For example, you could
have split the patches into three sets: important bug fixes, firmware
debugging and the rest. That helps everyone and saves time.

-- 
Kalle Valo