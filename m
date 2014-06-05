Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34709 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaFEP7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 11:59:05 -0400
Message-ID: <539093C8.2060908@candelatech.com> (sfid-20140605_175909_934290_40D6204A)
Date: Thu, 05 Jun 2014 08:59:04 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Emmanuel Grumbach <egrumbach@gmail.com>,
	ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Firmware debugging patches?
References: <53891ACD.7070902@candelatech.com> <87wqczz3h9.fsf@kamboji.qca.qualcomm.com> <538CA904.4000508@candelatech.com> <87ioojz1b1.fsf@kamboji.qca.qualcomm.com> <538CB782.1000509@candelatech.com> <538CC68C.10808@gmail.com> <538CC949.5020901@candelatech.com> <87fvjjpqqe.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87fvjjpqqe.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2014 03:58 AM, Kalle Valo wrote:
> Ben Greear <greearb@candelatech.com> writes:
> 
>> I am not sure this is really the case currently.  But, once the
>> blob is generated and stored in RAM, it would be easily enough to
>> add ethtool option to dump it w/out debugfs support.  This will
>> still not really address my concerns because it may take a year
>> or two for the latest ethtool binary to make it to normal-ish users.
> 
> [...]
> 
>> I think ethtool would not be overly hard to implement...basic framework is already
>> in the wifi stack.
> 
> Few weeks back John Linville sent ethtool related patches to support
> something like this. Did you notice that?


I didn't...but will take a look once I get my pending patches
dealt with.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

