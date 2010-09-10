Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51997 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab0IJS64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 14:58:56 -0400
Message-ID: <4C8A7FEC.4040603@candelatech.com>
Date: Fri, 10 Sep 2010 11:58:52 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Rajkumar Manoharan <rmanoharan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k oops on rmmod
References: <4C891102.40406@candelatech.com> <20100910050719.GA3959@vmraj-lnx.users.atheros.com> <AANLkTinfvgzTcZjOvzpbNm+fbwH3m-7jZgL9ktNKzh8D@mail.gmail.com>
In-Reply-To: <AANLkTinfvgzTcZjOvzpbNm+fbwH3m-7jZgL9ktNKzh8D@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/10/2010 11:44 AM, Luis R. Rodriguez wrote:
> On Thu, Sep 9, 2010 at 10:07 PM, Rajkumar Manoharan
> <rmanoharan@atheros.com>  wrote:
>> The following commit solves the issue.
>>
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8a2e8e5dec7e29c56a46ba176c664ab6a3d04118
>
> Um, was this a stable fix?

It's in upstream 2.6, but not in wireless-testing.

Thanks,
Ben

>
>    Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

