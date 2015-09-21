Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:46257 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbbIUPvL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 11:51:11 -0400
Subject: Re: [PATCH] ath10k: Fix CCK rate definitions.
To: Michal Kazior <michal.kazior@tieto.com>
References: <1442362098-24859-1-git-send-email-greearb@candelatech.com>
 <CA+BoTQkXma5KXpGa3XnnFw=13GRVoTEth0_=K-YNEKru1CpaOA@mail.gmail.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <5600276E.6080408@candelatech.com> (sfid-20150921_175134_072911_2DE66E30)
Date: Mon, 21 Sep 2015 08:51:10 -0700
MIME-Version: 1.0
In-Reply-To: <CA+BoTQkXma5KXpGa3XnnFw=13GRVoTEth0_=K-YNEKru1CpaOA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2015 12:33 AM, Michal Kazior wrote:
> On 16 September 2015 at 02:08,  <greearb@candelatech.com> wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> The old values did NOT match what is found in 10.1.467
>> firmware.  I figure it is likely it is wrong for the others
>> as well.
>
> Does this fix anything at all?

I'm adding support to CT firmware to set arbitrary ratectrl
masks, and I'm using that enum for part of the implementation.

In the 4.0 kernel, the 'hw-value' for CCK rates is broken since the enum doesn't
match firmware.

I'll check what code is using that enum and see if it can be fixed.  Otherwise,
I can fix it with a new enum with the values I need.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

