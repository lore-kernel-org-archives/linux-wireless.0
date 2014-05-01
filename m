Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:47295 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaEAInZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2014 04:43:25 -0400
Received: by mail-ig0-f180.google.com with SMTP id c1so256843igq.7
        for <linux-wireless@vger.kernel.org>; Thu, 01 May 2014 01:43:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P3=vC26x-EotmprmsnnpXwO+uDWUoVMohwsf2iO+zW8nQ@mail.gmail.com>
References: <CABtfrpCY7cOkw-dPwv5=8YxNAd4idpvyQV9zL3gU9RQiaSxpCw@mail.gmail.com>
	<CANUX_P0fLsNx+c7VnVggbZSGvnarF3inP7M115p-up3DfXyuuA@mail.gmail.com>
	<CABtfrpDYL55KJ=Ehr0E8wNtLMbcMmJohz3oA9BgtriMv7hw_qw@mail.gmail.com>
	<CABtfrpAY7OvH38E_+4QLGwWr2iQB1Rq45zzxdZwdM2Q7rc1NpA@mail.gmail.com>
	<5350B340.9020201@gmail.com>
	<53512D04.5070808@gmail.com>
	<CABtfrpB440bsy7xDu1pdTu2zM+ZJHLDQKb4MLaMRf4hnVXBsNQ@mail.gmail.com>
	<53513BC4.7020502@gmail.com>
	<CABtfrpDcZq=Ss=Zv9u0P3vz1D8rmgJ_jXGut-kZ0tkOmDZq9aw@mail.gmail.com>
	<535363D5.4070708@gmail.com>
	<CANUX_P3=vC26x-EotmprmsnnpXwO+uDWUoVMohwsf2iO+zW8nQ@mail.gmail.com>
Date: Thu, 1 May 2014 12:43:25 +0400
Message-ID: <CABtfrpAcED4yM9Cg027uz9YaeyDtJYqh-Hs0kF9Pvk=e7TXj_w@mail.gmail.com> (sfid-20140501_104330_294287_61C679C0)
Subject: Re: iwlwifi null pointer dereference
From: Alexander Monakov <amonakov@gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 1, 2014 at 5:19 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>> It bisects to
>>>
>>> commit 2dbc368d7fded35ed221a3751405b15e06eb8925
>>> Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>>> Date:   Mon Dec 9 11:09:47 2013 +0200
>>>
>>>     iwlwifi: pcie: track interrupt mask in SW
>>>
>>
>> Yeah - ok.
>> Thank you for this information.
>> I'll check again later.
>
> Can you try this? I guess it won't work, but I want to be sure about it.

Indeed, it still fails for me with that patch on top of 3.14.0.

Anything else I can do?
