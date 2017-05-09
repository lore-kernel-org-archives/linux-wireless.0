Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway32.websitewelcome.com ([192.185.145.170]:19962 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752461AbdEIMzT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 08:55:19 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 48FEE38A4E9
        for <linux-wireless@vger.kernel.org>; Tue,  9 May 2017 07:34:43 -0500 (CDT)
Date: Tue, 09 May 2017 07:34:42 -0500
Message-ID: <20170509073442.Horde.Q8CbZi0XhNUcuRQ3NxtQfks@gator4166.hostgator.com> (sfid-20170509_145523_770886_E7A993D4)
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH] net: wireless: ath: ath10k: remove unnecessary code
References: <20170509042159.GA19727@embeddedgus>
 <87lgq6387s.fsf@kamboji.qca.qualcomm.com>
 <76408651-07c6-fe31-863f-e1cb73b49663@broadcom.com>
In-Reply-To: <76408651-07c6-fe31-863f-e1cb73b49663@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

Quoting Arend Van Spriel <arend.vanspriel@broadcom.com>:

> On 9-5-2017 7:33, Kalle Valo wrote:
>> "Gustavo A. R. Silva" <garsilva@embeddedor.com> writes:
>>
>>> The name of an array used by itself will always return the array's address.
>>> So these tests will always evaluate as false and therefore the _return_
>>> will never be executed.
>>>
>>> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
>>
>> I don't understand the commit log, especially what does "The name of an
>> array used by itself" mean?
>
> The array fields in struct wmi_start_scan_arg that are checked here are
> fixed size arrays so they can never be NULL.
>
> Maybe that helps rephrasing this commit message.
>

Definitely. Thank you!
--
Gustavo A. R. Silva
