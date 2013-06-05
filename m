Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:52629 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756350Ab3FERDa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 13:03:30 -0400
Received: from mailout-de.gmx.net ([10.1.76.17]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0LfDle-1U4adt0VY0-00onUJ for
 <linux-wireless@vger.kernel.org>; Wed, 05 Jun 2013 19:03:29 +0200
Message-ID: <51AF6F5D.5020400@rempel-privat.de> (sfid-20130605_190342_224083_C3F9D5CC)
Date: Wed, 05 Jun 2013 19:03:25 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@blackshift.org>
CC: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH] ath9k_htc: fix skb_under_panic error
References: <51ADBC01.6090202@blackshift.org> <1370371064-6903-1-git-send-email-linux@rempel-privat.de> <CAGXE3d9p7zkwfNJBJvPMc8XaKnb009pHpCXYweDjK4tv6PCkuA@mail.gmail.com> <51AF4AA7.6050005@blackshift.org> <51AF4F35.50503@rempel-privat.de>
In-Reply-To: <51AF4F35.50503@rempel-privat.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 05.06.2013 16:46, schrieb Oleksij Rempel:
> Am 05.06.2013 16:26, schrieb Marc Kleine-Budde:
>> On 06/05/2013 04:24 PM, Helmut Schaa wrote:
>>> On Tue, Jun 4, 2013 at 8:37 PM, Oleksij Rempel
>>> <linux@rempel-privat.de> wrote:
>>>> This error seems to be really rare, and we do not know real couse of
>>>> it.
>>>> But, in any case, we should check size of head before reducing it.
>>>
>>> Mind to try the (completely untested) patch against wireless-testing
>>> instead?
>>> Helmut
>>
>> I will do, however I'm not in range of that USB wireless adapter for
>> about 1,5 weeks.
>
> Helmut, thank you for patch!
>
> i'll do regression test, but not week long test. So i probably won't
> reproduce this issue.

I was running two stream netperf test for 2 hours without visible 
regressions.



-- 
Regards,
Oleksij
