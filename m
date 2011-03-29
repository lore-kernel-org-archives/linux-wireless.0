Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:47811 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab1C2UX3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 16:23:29 -0400
Received: from mail.lockie.ca (dyn-dsl-lh-98-124-36-5.nexicom.net [98.124.36.5])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p2TKNR8D022761
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 16:23:28 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 39EEF1E0602
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 16:23:27 -0400 (EDT)
Message-ID: <4D923FC3.3010309@lockie.ca>
Date: Tue, 29 Mar 2011 16:23:31 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
CC: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: regdomain
References: <4D91697C.2050603@lockie.ca> <AANLkTikUfjM1eDprL_YDFuasVvTdpRoAzKXStJf-5C7e@mail.gmail.com>
In-Reply-To: <AANLkTikUfjM1eDprL_YDFuasVvTdpRoAzKXStJf-5C7e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/29/11 14:06, Luis R. Rodriguez wrote:
> On Mon, Mar 28, 2011 at 10:09 PM, James <bjlockie@lockie.ca> wrote:
>> I am in Canada so is 0x10 right?
> Nope
Well, I bought the card used, I just assume he bought it retail.
> But the Canada regulatory domain is indeed not being used. The differences:
>
> country CA:
>         (2402 - 2472 @ 40), (3, 27)
>         (5170 - 5250 @ 40), (3, 17)
>         (5250 - 5330 @ 40), (3, 20), DFS
>         (5490 - 5710 @ 40), (3, 20), DFS
>         (5735 - 5835 @ 40), (3, 30)
>
> country US:
>         (2402 - 2472 @ 40), (3, 27)
>         (5170 - 5250 @ 40), (3, 17)
>         (5250 - 5330 @ 40), (3, 20), DFS
>         (5490 - 5600 @ 40), (3, 20), DFS
>         (5650 - 5710 @ 40), (3, 20), DFS
>         (5735 - 5835 @ 40), (3, 30)

It is using CO, not US.

I am trying to debug this card since it works on kernel-2.6.36.2 but not
any later one.

