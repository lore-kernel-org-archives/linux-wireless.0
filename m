Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway30.websitewelcome.com ([192.185.149.4]:15455 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932455AbeD0Npy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Apr 2018 09:45:54 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 853E48D46
        for <linux-wireless@vger.kernel.org>; Fri, 27 Apr 2018 08:45:53 -0500 (CDT)
Subject: Re: [PATCH] rsi: fix a bug in rsi_hal_key_config()
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20180427112130.GA27655@mwanda>
 <87o9i46g1n.fsf@kamboji.qca.qualcomm.com>
 <20180427114449.pil7fgddcvpapgrq@mwanda>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <620e9073-5a26-ce77-6e7d-cf7dfcecab79@embeddedor.com> (sfid-20180427_154558_529165_9472AFD1)
Date: Fri, 27 Apr 2018 08:45:51 -0500
MIME-Version: 1.0
In-Reply-To: <20180427114449.pil7fgddcvpapgrq@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On 04/27/2018 06:44 AM, Dan Carpenter wrote:
> On Fri, Apr 27, 2018 at 02:32:20PM +0300, Kalle Valo wrote:
>>
>> Gustavo submitted an identical patch also for this one :)
>>
>> https://patchwork.kernel.org/patch/10365997/
>>
> 
> Hey Gustavo,
> 
> We keep on sending duplicate patches.  Most of the static checker people
> CC kernel-janitors@vger.kernel.org so we can see what's already been
> sent.
> 

Oh, I didn't know that.  I'll start CCing that list then.

Thanks for letting me know.
--
Gustavo
