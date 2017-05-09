Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway21.websitewelcome.com ([192.185.45.155]:27461 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751368AbdEIMAn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 08:00:43 -0400
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id B26A8400DABE5
        for <linux-wireless@vger.kernel.org>; Tue,  9 May 2017 07:00:40 -0500 (CDT)
Date: Tue, 09 May 2017 07:00:40 -0500
Message-ID: <20170509070040.Horde.6Ij5mVFBAtwRRwxv1IUZfj_@gator4166.hostgator.com> (sfid-20170509_140047_284322_18A39A14)
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH] net: wireless: ath: ath10k: remove unnecessary code
References: <20170509042159.GA19727@embeddedgus>
 <87lgq6387s.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87lgq6387s.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

Quoting Kalle Valo <kvalo@qca.qualcomm.com>:

> "Gustavo A. R. Silva" <garsilva@embeddedor.com> writes:
>
>> The name of an array used by itself will always return the array's address.
>> So these tests will always evaluate as false and therefore the _return_
>> will never be executed.
>>
>> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
>
> I don't understand the commit log, especially what does "The name of an
> array used by itself" mean?
>

Let me correct that and I'll send the patch again.

Thanks!
--
Gustavo A. R. Silva
