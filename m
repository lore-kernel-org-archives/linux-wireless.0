Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49555 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbaI2P67 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 11:58:59 -0400
Message-ID: <542981C1.7020000@candelatech.com> (sfid-20140929_175902_974347_8AAEFED0)
Date: Mon, 29 Sep 2014 08:58:57 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: request firmware flush in ath10k_flush.
References: <1411151304-31544-1-git-send-email-greearb@candelatech.com> <CA+BoTQm1rZO+yBbYxihpgEvR1cGZWS4Pr0AP+KMODcG4jpd_jQ@mail.gmail.com> <5421818A.9040501@candelatech.com> <CA+BoTQkZaGSkC9mhE8UF0He0RZWmPghDukdE1A5qiO1UNAZj5Q@mail.gmail.com> <871tqu3dgu.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <871tqu3dgu.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/29/2014 03:53 AM, Kalle Valo wrote:

>> Thanks. I think ath10k should do this instead of having CT-specific
>> flush eventually.
> 
> I agree. We should not be forking functionality unless absolutely
> necessary.

Ok, this patch is easy to carry in my own tree.

But, for things upstream firmware just cannot support,
like tx-rate-status and rx-software-crypt, how do you
want it flagged in the driver?  Can I get the CT firmware
flag in for that, or does it have to be some other way?

If you just will not accept any such patch, let me know so
I can quite bothering you about it.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

