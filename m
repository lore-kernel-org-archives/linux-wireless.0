Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:36229 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933364AbdDXHqp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Apr 2017 03:46:45 -0400
Received: by mail-yw0-f174.google.com with SMTP id l18so14364576ywh.3
        for <linux-wireless@vger.kernel.org>; Mon, 24 Apr 2017 00:46:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87inludzh6.fsf@michaelmera.com>
References: <20170424053902.1644-1-dev@michaelmera.com> <CAN6Sofawy9BmFaVgNw=gt=9VwLqNFdCQ2fa3DApvJTVCJpjoqg@mail.gmail.com>
 <87inludzh6.fsf@michaelmera.com>
From: Marcin Rokicki <marcin.rokicki@gmail.com>
Date: Mon, 24 Apr 2017 09:46:43 +0200
Message-ID: <CAN6SofY1Job1qpTwzmMAqE-+eK5vk01bNU5-WK8k28yL9YuS9w@mail.gmail.com> (sfid-20170424_094732_196754_767F62F8)
Subject: Re: [PATCH] ath10k: fix out of bounds access to local buffer
To: Michael Mera <dev@michaelmera.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2017-04-24 9:41 GMT+02:00 Michael Mera <dev@michaelmera.com>:
> Marcin Rokicki <marcin.rokicki@gmail.com> writes:
>> Please send again to ath10k@lists.infradead.org with cc
>> linux-wireless@vger.kernel.org
>>
>
> Sorry for the mistake. Resent as requested.

No problem.
>
> Just for the record, I followed instructions at:
>   https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches?s[]=submit#who_to_address
>
> So, maybe this needs to be updated to reflect the ath10k case.

Check this page:
https://wireless.wiki.kernel.org/en/users/drivers/ath10k/sources
>
> Thanks,
> Michael Mera
