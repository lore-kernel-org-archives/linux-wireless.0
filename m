Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54175 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbcCOHeY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2016 03:34:24 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2016-03-14
References: <87y49llatn.fsf@kamboji.qca.qualcomm.com>
	<20160314.121528.1217892668324346880.davem@davemloft.net>
Date: Tue, 15 Mar 2016 09:34:18 +0200
In-Reply-To: <20160314.121528.1217892668324346880.davem@davemloft.net> (David
	Miller's message of "Mon, 14 Mar 2016 12:15:28 -0400 (EDT)")
Message-ID: <87twk8kxdx.fsf@kamboji.qca.qualcomm.com> (sfid-20160315_083432_712509_6746BF43)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller <davem@davemloft.net> writes:

> From: Kalle Valo <kvalo@codeaurora.org>
> Date: Mon, 14 Mar 2016 10:31:48 +0200
>
>> I know I'm late now that merge window was opened yesterday but here's
>> one more set of patches I would like to get to 4.6 still. There isn't
>> anything controversial so I hope this should be still safe to pull. The
>> patches have been in linux-next since Friday and I haven't seen any
>> reports about issues. But if you think it's too late just let me know
>> and I'll resubmit these for 4.7.
>> 
>> The most notable part here of course is rtl8xxxu with over 100 patches.
>> As the driver is new and under heavy development I think they are ok to
>> take still. Otherwise there are mostly fixes with an exception of adding
>> a new debugfs file to wl18xx.
>> 
>> Please let me know if you have any problems.
>
> Pulled, thanks.

Great, thanks a lot.

> I really like Jes's work and I wish you had integrated it several
> months ago, instead of sloshing him needlessly through a non-stop
> cycle of very nit-picky issues, just FYI.

I also like his work and I'm sorry for being too nit-picky. I have tried
to be extra careful with the patches I send to you, especially with new
drivers, and I guess I have been too pedantic. I'll try to lower the bar
to a more reasonable level.

But I actually started to wonder what you actually mean and checked the
dates of initial rtl8xxxu submission from patchwork:

2015-08-29 v1
2015-08-30 v2
2015-10-15 v3
2015-10-21 applied 26f1fad29ad9 to w-d-next for v4.4

Two months is quite long for a good driver like this but IIRC the
initial commit was pending wireless-drivers directory reorganisation,
and that just took too long on my side.

-- 
Kalle Valo
