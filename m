Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8345 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbaENNeN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 09:34:13 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/7] ath10k: recovery improvements 2014-05-09
References: <1399638957-20449-1-git-send-email-michal.kazior@tieto.com>
	<CA+BoTQ=VxSu9q_w3tjMNikKxuiMAfW5=k9La_AK3PoP8azgFUA@mail.gmail.com>
Date: Wed, 14 May 2014 16:34:05 +0300
In-Reply-To: <CA+BoTQ=VxSu9q_w3tjMNikKxuiMAfW5=k9La_AK3PoP8azgFUA@mail.gmail.com>
	(Michal Kazior's message of "Mon, 12 May 2014 09:34:53 +0200")
Message-ID: <87oaz0fprm.fsf@kamboji.qca.qualcomm.com> (sfid-20140514_153419_494560_80276746)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 9 May 2014 14:35, Michal Kazior <michal.kazior@tieto.com> wrote:
>> Hi,
>>
>> This depends on my `ath10k: recovery fixes
>> 2014-05-09`.
>>
>> Hopefully the split makes it a little saner to
>> review.
>>
>> Please note: `ath10k: make wmi timeout trigger hw
>> restart` effectively hides the mgmt tx / htc
>> credit starvation issue that was discussed
>> recently. My intention is to make the driver more
>> robust and as a side effect it makes the
>> starvation issue less painful. If desired so
>> the patch can be easily ignored in the series as
>> nothing depends on it.
>>
>>
>> Michal Kazior (7):
>>   ath10k: move restart_work call
>>   ath10k: introduce core restart symbol
>
>
>>   ath10k: drain wmi quickly upon hw restart
>>   ath10k: wake up everything on core restart
>
> These 2 are harmful as they are. In case of early fw crash
> uninitialized structures are accessed. I'll re-spin later.

So I can drop the whole series, right?

-- 
Kalle Valo
