Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:44588 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030180AbcFBPcL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2016 11:32:11 -0400
Message-ID: <57505179.8090509@candelatech.com> (sfid-20160602_173215_289190_B2E2E141)
Date: Thu, 02 Jun 2016 08:32:09 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mike@fireburn.co.uk" <mike@fireburn.co.uk>
Subject: Re: Bug 119151 - [regression] ath10k no longer authenitcates and
 freezes system
References: <8760trzoiw.fsf@kamboji.qca.qualcomm.com>	<871t4fzn1x.fsf@kamboji.qca.qualcomm.com>	<57504F05.3040200@candelatech.com> <87k2i7y5m2.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87k2i7y5m2.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/02/2016 08:26 AM, Valo, Kalle wrote:
> Ben Greear <greearb@candelatech.com> writes:
>
>> I found a lot of problems with this code as well, and the 5 patches
>> starting from the URL below fixed the issues for me.
>>
>> They are stuck as 'NA' in patchwork, but I don't know why.
>>
>> http://lists.infradead.org/pipermail/ath10k/2016-April/007218.html
>
> ath10k has a separate patchwork instance, did you look at the correct
> one? I have quite a lot of patches from you in deferred state because of
> the patch bomb, but I'm hoping to go through them soon.
>
> https://patchwork.kernel.org/project/ath10k/list/?state=10&delegate=25621&order=date

Ok, they are deferred then.

The series of 5 is likely quite useful and fixes some nasty bugs,
and the first patch of the big bomb is also a trivial crash fix
for a regression you added (as best as I can tell).

The rest of the patch bomb is less critical, but making some progress on
that would make me feel good about working on ath10k patches again.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
