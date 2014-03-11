Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44386 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaCKLQ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 07:16:57 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: unify warning messages in mac.c
In-Reply-To: <8761nv44nd.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Mon, 3 Mar 2014 18:40:22 +0200")
References: <20140303154327.1290.67278.stgit@potku.adurom.net>
	<CA+BoTQmQndikH5uPDwBpstp9KmcD3tmHSGP5NpEreYEOtRm0sw@mail.gmail.com>
	<8761nv44nd.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 11 Mar 2014 13:16:46 +0200
Message-ID: <87k3c1gf35.fsf@kamboji.qca.qualcomm.com> (sfid-20140311_121701_499955_E6D9567F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

>> I think we should agree on one of the two approaches:
>>
>> a) start with a verb:
>>
>> "failed to add peer %pM on vdev %i: %d"
>> "failed to initialize dfs pattern detector"
>> "timed out while waiting for scan completion"
>>
>> b) start with a noun:
>>
>> "peer %pM on vdev %i could not be added: %d"
>> "dfs pattern detector could not initialize"
>> "scan timed out"
>>
>> These are still mixed.
>>
>> We could probably also limit the set of verbs, e.g. replace "could
>> not" with "failed to" as it's practically the same thing (assuming we
>> pick (a)).
>
> That's true. I would vote for option (a).

I didn't get any comments about Michal's proposal. Can I conclude from
this that (a) above is ok for everyone?

-- 
Kalle Valo
